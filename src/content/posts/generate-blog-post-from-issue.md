
---
title: "hugo 使っているけどスマホで記事を書きたいと思ったので"
date: 2021-02-13T15:21:00+09:00
draft: false
categories: ["その他"]
---
           
GitHub issue をブログ記事に変換する仕組みを GitHub Actions を使ってこしらえてみた。

<!--more-->

できたもの
- [issue を pull request に変換する GitHub Action](https://github.com/pankona/pankona.github.com/blob/hugo/.github/workflows/generate_pr_from_issue.yaml)
- ついでに [pull request マージ後にサイトをビルド＆デプロイする GitHub Action (手動)](https://github.com/pankona/pankona.github.com/blob/hugo/.github/workflows/generate_site_and_deploy.yaml)

## 背景

本ブログの生成には hugo という静的サイトジェネレータを使っており、基本的には PC を使って執筆、生成、デプロイまで行うような建付けで運用している。が、ときどきスマホで記事が書けなくて不便だなーと思うことがあり、うまいやり方はないものかと考えていた。

うすらぼんやり考えていた要件としては、
- スマホでちゃちゃっと記事が書ける
- マークダウンみたいなもので書くことができる
- あわよくば既存の記事を後から編集できる

みたいなもの。

hugo にはいわゆるワードプレスみたいな管理画面がない。[Netlify CMS](https://www.netlifycms.org) みたいなものを使うと管理画面をこしらえることができるようなことが書いてある気がするけれど、それをまた運用するのも面倒だし、もうちょっと簡単に済ませらんないかなー等と考えていた。

## GitHub issue をブログ記事に変換するというやり口

ふと、GitHub issue ならばスマホで何となく書くことができ、しかもマークダウンであり、何なら画像貼ったりもできるし、というので要件を満たすものに近いんではないかということに気づいた。なんならもう GitHub issue をそのままブログですって言い張っていく線まで考えたが、せっかく hugo あるし、うまい具合に "GitHub issue をブログ記事に変換" できたら便利かもなー、ということでちょっと作ってみた。本記事もさっそく GitHub issue からの生成してみている。

## どういったものを作ったか

GitHub Actions で基本的には済ませることができそうだった。
- issue の更新イベントを捕まえて
- ブログのリポジトリをクローン
- issue を取得、hugo が食えるフォーマットに変換し、ブログのリポジトリの所定の位置に配置
- commit して push して pull request にする
- pull request を自分がなんとなくレビューしたらマージ
- マージしたら actions 等を用いて自動的にサイトを生成してデプロイ

## 課題

なんとなく使えそうだけどもいくらか課題があり、
- issue 変更時には pull request を更新してほしいが、次々 commit を積むというのも難しいので force push にしている
  - これは PC での編集と相性が悪いようにも思える (pull request を PC で編集したら issue 側に反映させないといけない気がする)
- 自分以外が issue を立てたときもブログ記事になってしまう。ﾜﾛｽ
  - これは actions 実行の条件として、issue を起票あるいは変更イベントを発行した author が自分であること、というのを入れればよさそう
  - (追記) その後、issue を変更した人が "pankona" でなかったら actions を何もしないで終了するようにしてみた。勝ったか！？

## 書けよ

仕組みを作るのはいいがちゃんとブログを書こうな (戒め)

