---
title: "定期実行している GitHub Actions はリポジトリに 60 日間アクティビティがないと止められる"
date: 2022-02-27T01:39:42+09:00
draft: false
categories: ["GitHub Actions"]
---

GitHub から「更新のないリポジトリで使ってる定期実行 GitHub Actions 止めるからね、もうすぐだからね」っていうお知らせがきた。そんな制限があるとは知らなかった。

<!--more-->

GitHub 曰く、

```plaintext
Scheduled workflows are disabled automatically after 60 days of repository inactivity
```

ということらしい。60 日間リポジトリにアクティビティがなかったら定期実行が止まるようだ。ふむ。

## GitHub Actions の定期実行で pankona は何をしているのか

ブログ更新を自分に促すために、「最後のブログ更新から○日が過ぎました」というお知らせを Slack に通知するようにしている。この通知はデイリーで行うようしていて、定期実行には GitHub Actions の機能を使っている。

しばらくブログ更新をサボっていたらこのようなお知らせをいただくことになった。つまりおよそ 60 日間はブログ更新してなかったことが分かる。定期実行を止めたくなければブログを更新しなければならない。ブログ更新を強いられるという意味ではなかなか悪くない仕組みかもしれない。
