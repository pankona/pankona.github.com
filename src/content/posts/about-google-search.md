---
title: "Google Japanの検索にgithubがヒットしないかと思ったがそんなことはなかった"
date: 2014-05-19 21:21:34 +0900
comments: true
categories: [その他]
---

## 自分のページがGoogle検索にヒットしない理由

なかなか自分のページ（ここのブログのこと）がGoogle検索に引っかからないので、
いや、大層なことを書いているわけでもないから引っかからなくても怒ったりはしないが、
いやでもなんで引っかからないんだろう、と思って調査をしていたところ、

### GithubのリポジトリはGoogle日本の検索に引っかからない

といった記事を見つけた。ほんまかいな？
もしかしてそのせいでうちのページはGoogleに引っかからないんじゃああるまいか？
（Github pagesを使って公開しているページなので）

等と考えつつ、調査を続行していったところ、、、

### 結論からすると、GithubのリポジトリはGoogle日本の検索にちゃんと引っかかる。

ただし条件がある模様。それは（おそらく）、

**ページ（リポジトリの場合はREADMEかな？）に日本語が含まれていること**

つまり、Google日本の検索に引っかからない、というよりは、
**"日本語のページを検索"**に引っかからない、ということである模様。
全編英語で書いてたら英語のページと判断して、"日本語のページを検索"には載せない、ってことかなー。
そして、Google日本の検索は、おそらくデフォルトは"日本語のページを検索"になってる。という話。

加えて、GithubのリポジトリのREADMEなんかは、英語だけで書かれているケースが多い。
だからGoogle日本を使ってそのまま検索をしていると、Githubのページがあんまり出てこないという現象が。

だので、英語だけで書かれたGithubのページも、検索オプションで言語に依らない検索にしてあげれば、Google日本の検索でも出てきます。

### じゃあ日本の人にもリポジトリにリーチしてもらうにはどうするか？

自分のGithubのリポジトリに日本人を呼び込みたい！と思ったら、READMEに日本語をちょっと混ぜてあげればリーチできる人が増えるかも？
と思っているがどうか。たぶん、おそらく、きっと、効果あると思われる。つまり自信ない。
自分のリポジトリ使って実験してみます。そのうち調査結果を書きます。
