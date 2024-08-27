package main

import (
	"bufio"
	"bytes"
	"context"
	"flag"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"
	"text/template"
	"time"

	"github.com/google/go-github/v33/github"
	"golang.org/x/oauth2"
)

func main() {
	issueNum := flag.Int("issue-num", 0, "specify issue number to convert to blog post")
	flag.Parse()

	ctx := context.Background()
	ts := oauth2.StaticTokenSource(
		&oauth2.Token{AccessToken: os.Getenv("GITHUB_TOKEN")},
	)
	tc := oauth2.NewClient(ctx, ts)
	client := github.NewClient(tc)

	issue, resp, err := client.Issues.Get(context.Background(), "pankona", "pankona.github.com", *issueNum)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()

	w := &bytes.Buffer{}
	err = write(w, Article{
		Title: extractTitleFromBody(*issue.Body),
		Body:  removeTitleFromBody(*issue.Body),
		Date:  *issue.CreatedAt,
		Draft: strings.Contains(*issue.Title, "[draft]"),
		Categories: func() []string {
			ret := make([]string, 0, len(issue.Labels))
			for _, label := range issue.Labels {
				labelName := label.GetName()
				if labelName != "article" && labelName != "" {
					ret = append(ret, label.GetName())
				}
			}
			return ret
		}(),
	})
	if err != nil {
		panic(err)
	}
	fmt.Printf("%s\n", w.String())
}

func extractTitleFromBody(body string) string {
	scanner := bufio.NewScanner(strings.NewReader(body))
	if scanner.Scan() {
		return scanner.Text()
	}
	return "no title"
}

func removeTitleFromBody(body string) string {
	scanner := bufio.NewScanner(strings.NewReader(body))

	ret := []string{}
	i := 0
	for scanner.Scan() {
		if i == 0 || i == 1 {
			i++
			continue
		}
		ret = append(ret, scanner.Text())
	}
	return strings.Join(ret, "\n")
}

type Article struct {
	Title      string
	Body       string
	Date       time.Time
	Draft      bool
	Categories []string
}

func write(w io.Writer, article Article) error {
	jst, err := time.LoadLocation("Asia/Tokyo")
	if err != nil {
		return err
	}
	data := map[string]interface{}{
		"Title": article.Title,
		"Date":  article.Date.In(jst).Format(time.RFC3339),
		"Draft": article.Draft,
		"Categories": func() string {
			ret := make([]string, 0, len(article.Categories))
			for _, c := range article.Categories {
				ret = append(ret, strconv.Quote(c))
			}
			return strings.Join(ret, ",")
		}(),
		"Body": article.Body,
	}

	const articleTemplate = `---
title: >-
  {{.Title}}
date: {{.Date}}
draft: {{.Draft}}
categories: [{{.Categories}}]
---

{{.Body}}
`

	t, err := template.New("article").Parse(articleTemplate)
	if err != nil {
		return err
	}

	return t.Execute(w, data)
}
