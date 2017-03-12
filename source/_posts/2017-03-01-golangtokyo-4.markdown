---
layout: post
title: "golang.tokyo#4@eureka"
date: 2017-03-01 19:31:27 +0900
comments: true
categories: golang
---

2017.03.01 に eureka さんにて、golang.tokyo #4 が行われました。

[golang.tokyo #4 - connpass](https://golangtokyo.connpass.com/event/50714/)


今回もまた大盛況で一般参加枠は倍率3倍くらいの抽選となっていましたが、
たまたまブログ枠が空いているところに遭遇してしまったため、またしてもブログ枠として
参加させていただきました。内容をレポートしていきます。

発表内容の詳細は、実際発表に用いられたスライド (上記 connpass のページから辿れます) を参照いただくのが一番良いと思いますので、
本記事ではその他、イベントの雰囲気や私の感想を主にお伝えしていくような体になります。
それではいきます。今回のテーマは **「concurrency」** 。

--- 

# Concurrency for distributed Web crawlers by puhitaku さん

<a class="embedly-card" data-card-key="ee29ed4b275e459483a608ca67084559" data-card-controls="0" href="https://speakerdeck.com/puhitaku/concurrency-for-distributed-web-crawlers">Concurrency for distributed Web crawlers</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

(↑のカードをクリックでスライドに飛びます。)

## AppStore と Google Play をクロールして欲しい情報を収集するやつ

* クロール対象はシングルドメイン。だが対象となるアプリが多い (100k以上) 。
  * 同一IPからあんまりひどいことするとバンされたりする...。
  * とはいえあんまりちんたらやってるわけにもいかない。24時間以内にクロールし終わる必要がある。

* Commander と Crawler
  * AWS EC2 Container Service を使っている。
  * 一日30弱くらいのインスタンスを立ち上げて並列でクローリングする。

* 1 アプリあたりのクロール時間が見積もれないと困る。
  * 1 アプリあたりのクロール速度は割とまちまち。終わるの待ってたらクロール量が安定しない。
  * 一個あたりのクロールを goroutine で行う。
  * 規定時間を設ける。規定時間より超過した場合、終わってなくても次のタスクをスタートさせる。
  * という戦略で、時間あたりのクロール数を見積もれるという寸法。

* 落とし穴シリーズ
  * TCPコネクションを使い果たす問題。並列に行われるクロールの数が多すぎると TCP コネクションを使い果たしてしまう…。
  * この問題は、make(chan int, 100) みたくして、Channel が保持する値の数を制限することで対応。

--- 

# Goのスケジューラー実装とハマりポイント by niconegoto さん

<a class="embedly-card" data-card-key="ee29ed4b275e459483a608ca67084559" data-card-controls="0" data-card-type="article-full" href="https://talks.godoc.org/github.com/niconegoto/talks/concurrency.slide#1">Goのスケジューラー実装とハマりポイント</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

Goroutine の内部実装について。

## Goroutine の実装デザイン

* runtime を読む。
* https://golang.org/pkg/runtime

* M、G、P という文字が頻繁に出てくる。それらの意味は、
  * M ... Machine
  * G ... Goroutine
  * P ... Processor

## スケジューラーのハマりどころ

* C 言語の pthread なんかと同じで、goroutine もコンテキストスイッチを考慮する必要がある。
* [Morsing's Blog](https://morsmachine.dk/go-scheduler) に詳しいこと書いてある。

# Ridge a framework like GAE/Go on AWS by fujiwara さん

<a class="embedly-card" data-card-key="ee29ed4b275e459483a608ca67084559" data-card-controls="0" href="https://speakerdeck.com/fujiwara3/go-on-aws">Ridge - A framework like GAE/Go on AWS</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

Go で書いた HTTP Server を AWS Lambda で動かす…！

## Ridge の紹介

* [Ridge](https://github.com/fujiwara/ridge)
* 実質、GAE/Go みたいなことを AWS Lambda で実現できる
* 裏で goroutine を延々動かしておくみたいなことはできない。Lambda はレスポンス返し終わると寝てしまう。
  * 次のリクエストが来たら起きて続きの処理が行われていく
* 頻繁にアクセスがなく、レイテンシ要求がシビアでないようなものに向く
  * サービスが終了したゲームの告知 API とか。POST を受けて JSON を返す、という処理を EC2 使わないで行う。

* EC2 使わず、それでいてリクエスト数が多ければスケールする、ということで用途が合えば非常にリーズナブルにできる印象。

--- 

# ライブコーディング by kaneshin さん

![golang.tokyo-4](/images/golang.tokyo-4/1.jpg)
写真1. ライブコーディング直前の kaneshin さん

* tail コマンドを作る...!
* [完成したものはこちら](https://gist.github.com/kaneshin/a398720b8e20722a83bc6903e4017435)

## ポイント (と思ったところ)

* kaneshin さんは vim + vim-go プラグインを使って Go を書いている模様。
* channel をバッファのように扱っている。
* 入力を待ち受ける goroutine と、出力を担当する goroutine とで 2 並列。
今回のテーマにあった良い題材であると感じた。

--- 

# 嫁に怒られずに Go を書く技術 by teitei_tk

<a class="embedly-card" data-card-key="ee29ed4b275e459483a608ca67084559" data-card-controls="0" href="https://speakerdeck.com/teitei/jia-ninu-rarezunigowoshu-kuji-shu">嫁に怒られずにGoを書く技術</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

「嫁のため」という免罪符を得て開発していくスタイル

* LINE に天気予報だったりを投稿する。
* つまり生活に役立つというか家内に益があれば良いということ。
* 夫婦円満を願ってやまない。

--- 

# Gogland by Sergey Ignatov さん

![golang.tokyo-4](/images/golang.tokyo-4/2.jpg)
写真2. Gogland の開発者 Sergey Ignatov さん

JetBrains から Sergey Ignatov さんが来てくれて、Gogland の紹介をしてくれたぞ！

* function の定義に飛んで実装を確認する必要はなく、小窓で出せるような機能がある。便利そう。
* 引数のサジェストが賢い。ファジーサーチ的に動きつつ、型が合わないものはサジェストされない、等。
* 保存時に go fmt、 go import する機能も最近対応された。
* 2017年3月現在は EAP 版だが、年末くらいには EAP が取れて正式版になるような予定らしい。
* 意見・要望があったら [issue tracker](https://youtrack.jetbrains.com/issues/GO) へ！

---

ざっくりですが、かいつまんで golang.tokyo 4 回目の様子を紹介いたしました。
休憩時間にはビールも振る舞われたりして、無料でいいんですかという気持ちになります。
いつもありがとうございます。

次回もまた 4 月くらいに実施されるようなので、都合が合えば参加させていただこうかと思います。
