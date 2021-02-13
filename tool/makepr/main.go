package main

import (
	"context"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/google/go-github/v33/github"
	"golang.org/x/oauth2"
)

func main() {
	ctx := context.Background()
	ts := oauth2.StaticTokenSource(
		&oauth2.Token{AccessToken: os.Getenv("GITHUB_TOKEN")},
	)
	tc := oauth2.NewClient(ctx, ts)
	client := github.NewClient(tc)

	pr, resp, err := client.PullRequests.Create(context.Background(), "pankona", "pankona.github.com", &github.NewPullRequest{})
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		buf, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			panic(err)
		}
		panic(fmt.Sprintf("failed to create pull request. status code: %d, body: %s", resp.StatusCode, buf))
	}

	fmt.Printf("pull request created: %s\n", *pr.IssueURL)
}
