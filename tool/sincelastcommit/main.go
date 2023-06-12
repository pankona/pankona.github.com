package main

import (
	"fmt"
	"strings"
	"time"

	"github.com/go-git/go-git/v5"
)

func main() {
	r, err := git.PlainOpen(".")
	if err != nil {
		panic(err)
	}
	articlesDir := "content/posts"
	commits, err := r.Log(&git.LogOptions{
		PathFilter: func(path string) bool {
			return strings.HasPrefix(path, articlesDir)
		},
	})
	if err != nil {
		panic(err)
	}
	commit, err := commits.Next()
	if err != nil {
		panic(err)
	}

	lastCommitDate := commit.Author.When
	sinceLastCommit := time.Since(lastCommitDate)
	fmt.Printf("%d", int(sinceLastCommit.Hours()/24))
}
