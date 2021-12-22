---
title: "Alpine Linux 上で git command を叩くいたときに色がつかなかったり全画面 pager になったりするのは GNU の less が入っていないから"
date: 2021-12-22T20:00:08+09:00
draft: false
categories: ["Linux"]
---
           
Alpine Linux 上で作業をすることを余儀なくされるケースがあったのだが、git command が色々と気に食わない (macOS や自分が普段使いしている Linux と表示が異なるという意味) ことになっていた。
GNU less をインストールすることで解決したのでメモしておく。

<!--more-->

## 困り事

Alpine Linux で git command を叩くと、色々気に食わないことが起こる。

- `git branch` を実行すると、画面全部を使った pager が起動する (いっぱいブランチがあるときには便利かもしれないが…)。
- `git log` を実行したときに色がつかない。白黒。
- `git diff` みたいなものも色がつかない白黒。

## 解決策

less を入れる。

```
sudo apk add less
```

これだけで先述の諸々は解決する。`git branch` も省スペースな感じで表示されるし、`git log` も `git diff` も色付きになる。

## なんでこういうことが起こるのか

Alpine Linux に最初から入っている less は、Busybox 由来の less であるらしい。
Refs: https://wiki.alpinelinux.org/wiki/Alpine_Linux:FAQ#How_to_enable.2Ffix_colors_for_git.3F

曰く、
```
The problem is not in git itself or terminal, but in the less command. Busybox’s less doesn’t support -r (--raw-control-chars) and -R (--RAW-CONTROL-CHARS) options.
The simplest (yet not ideal) solution is to install GNU less:
apk add less
```
ということである。Busybox の less は省機能で作られているってことかしらね。

