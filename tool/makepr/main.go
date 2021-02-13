package main

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strings"

	"github.com/google/go-github/v33/github"
	"golang.org/x/oauth2"
)

func main() {
	base := flag.String("base", "", "specify base to create pull request")
	head := flag.String("head", "", "specify head to create pull request")
	body := flag.String("body", "", "specify pull request body to create pull request")
	flag.Parse()

	title := fmt.Sprintf("add a post by %s", *head)

	ctx := context.Background()
	ts := oauth2.StaticTokenSource(
		&oauth2.Token{AccessToken: os.Getenv("GITHUB_TOKEN")},
	)
	tc := oauth2.NewClient(ctx, ts)
	client := github.NewClient(tc)

	pr, resp, err := client.PullRequests.Create(context.Background(), "pankona", "pankona.github.com",
		&github.NewPullRequest{
			Title: &title,
			Head:  head,
			Base:  base,
			Body:  body,
		})
	var e *github.ErrorResponse
	if errors.As(err, &e) {
		for _, v := range e.Errors {
			if strings.Contains(v.Message, "A pull request already exists") {
				log.Printf("pull request already exists. do nothing")
				return
			}
		}
	} else if err != nil {
		panic(err)
	}

	defer resp.Body.Close()

	if resp.StatusCode != 201 {
		buf, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			panic(err)
		}
		panic(fmt.Sprintf("failed to create pull request. status code: %d, body: %s", resp.StatusCode, buf))
	}

	log.Printf("pull request created: %s", *pr.IssueURL)
}
