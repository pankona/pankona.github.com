---
layout: post
title: "Octopressカスタマイズで読書メーターのブログパーツを追加"
date: 2014-10-01 22:41:26 +0900
comments: true
categories: "Octopressカスタマイズ"
---

たまにはブログのカスタマイズをしてみる。
今回は読書メーターのブログパーツを追加してみた。

サイドバーに「最近読んだ本」なんてのが現れるようにしてみた。
文字ばっかだったブログにちょっと賑やかし感があって良い。

例によって備忘録的にやり方を残しておく。
Octopressに読書メーターのブログパーツを追加する方法。

### 読書メーターのアカウントを取得する

[読書メーターのウェブページ](http://book.akahoshitakuya.com/)からどうぞ。

### ブログパーツを選ぶ

読書メーターにログイン後、マイページに行ってみると、
**「ブログパーツ」**と書いてあるところがある。
そこを見ると各種ブログパーツを見つけることが出来る。

### Octopressをカスタマイズして、サイドバーに出るように

ここからはOctopress側の編集。

#### 読書メーター用のHTMLを書く。

中身は上記ブログパーツの内容をコピペしたものだが。
ブログパーツとして「最近読んだ本」をチョイス。

```html source/_includes/custom/asides/dokusho_meter.html
<section>
<a href="http://book.akahoshitakuya.com/u/{人によって違うID}" title="{人の名前}の最近読んだ本"><img src="http://img.bookmeter.com/bp_image/640/509/{人によって違うID}.jpg" border="0" alt="{人の名前}の最近読んだ本"></a>
</section>
```

#### _config.ymlを編集して、サイドバーにパーツを追加

_config.ymlのdefault_asidesを変更。読書メーター用HTMLファイルを指定。

```html _config.yml
default_asides: [custom/asides/about.html, asides/recent_posts.html, asides/github.html, asides/delicious.html, 
                 asides/pinboard.html, asides/googleplus.html, custom/asides/tag_cloud.html, custom/asides/category_list.html,
                 custom/asides/dokusho_meter.html]
```

#### deployしたら完了

```bundle exec rake gen_deploy``` 的なことをやってデプロイする。

### ここまでで

最近読んだ本がサイドバーに表示されるように。
ITっぽい本を並べたりすると、なんとなく技術的なブログな雰囲気が出て、
とてもいいんではないでしょうか。
