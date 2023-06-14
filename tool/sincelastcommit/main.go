package main

import (
	"fmt"
	"os/exec"
	"strings"
	"time"
)

func main() {
	lastCommitDateLine, err := exec.Command("git", "log", "-1", "--diff-filter=A", "--pretty=%aI", "--", "content/posts").Output()
	if err != nil {
		panic(err)
	}
	lastCommitDate, err := time.Parse(time.RFC3339, strings.TrimSpace(string(lastCommitDateLine)))
	if err != nil {
		panic(err)
	}
	sinceLastCommit := time.Since(lastCommitDate)
	fmt.Printf("%d", int(sinceLastCommit.Hours()/24))
}
