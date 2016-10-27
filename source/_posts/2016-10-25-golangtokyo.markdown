---
layout: post
title: "golang.tokyo #1"
date: 2016-10-25 19:38:13 +0900
comments: true
categories: golang
---

# 登壇者自己紹介 & どこで Go を使っているか

# メンバーのGoの教育はどうしてますか？

最初に見せる
辻さん
* tour of go、effective go
* 初心者が見ると幸せになる Go のページ
* LT
* 標準ライブラリのコード読んだり
* ハマりどころの勉強会
* 実践あるのみでソースレビュー
  * 経験ある人をレビュアーにいれる
  * Go っぽくないコードを指摘したり

# IDEやデバッグはどうしているか

songmu さん
* vim。結構バラバラ。
* デバッグ。print デバッグ、ちょっと書いてテスト書いて、みたいな。

大谷さん
* intellij idea、何人か vim
* デバッグ。print デバッグ、実際に動かしながら、みたいな。

## goimport で import を差し込む順番

* 変な順番で突っ込まれる
* 慣れる。
* delve を使っている例も

# コーディオング規約、レビューの指針、golint に従うか

辻さん
* コーディング規約は、go review comment を基準に
* 空 struct をチャンネルに使う
* golint はベストエフォート。3rd party が生成するコードが従ってない、とか。
  * 除外は grep -v で頑張る

songmu さん
* glint には従っている。従えば Go っぽい書き方ができてくると思う。

## gometalinger ってどうか

* 重い。fast ってコマンドあるにしても重い。

# Webフレームワークとテンプレートエンジンは？ORMは？

辻さん
* Echo。パフォーマンスで。
* テンプレートエンジンは、、、標準のが辛かった。front は Go で書いてない。
* squirrel

kaneshin さん
* 当初は revel だが重量級な感じでとっぱらいたかった。
  * Gin で置き換えた。
  * データ変換で gorrila の max。もしくは標準の http。
* テンプレートエンジンは標準のが辛い。Front は JS で SPA。
* ORM。XORM。
* 一部では gorm。

## フロントは…

* react とか angular とか使っちゃう

# エラー処理どうしてますか？pkg/errors？ panic は？

tenntenn さん
* pkg/errors。

songmu さん
* panic はなるべくしないように作る。
* goroutine の中でのエラーは、sync.ErrorGroup

deeeet さん
* ErrorGroup は便利。
* たくさんの処理があって、一個でも失敗したらご破産にしたいときに使う。
* pkg/errors は、

kaneshin さん
* error はエラーを上位レイヤーに伝搬させていく思想。
  * panic はしっかり使う。起動直後に実行されるたぐいのものとかに対して。

# Git に上がっているオススメの Go で書かれたもの

kaneshin さん
* aws-sdk-go。go でコードジェネレーションしているのが参考になる。
* リクエストの作り方、リクエストのリトライの仕方。パッケージの構造。
* gcp の sdk も。
* go-github。
* kaneshin/gate。Makefile の使い方。

# ロガーどうしている？

辻さん
* logrus。
* zap はどうか？使い勝手は特殊な感じだが速いとか。

大谷さん
* Web ではフレームワークのロガーをそのまま使う。
* fluentd でひっかけて Big Query に投げる。

# パッケージ分けどうしているか？パッケージ名、循環 import 問題は？

松本さん
* ひとつのサービス内のサブパッケージは2つか3つくらい。
  * 設計上のドメイン軸で切っていく。ニュース記事・ユーザー・...
  * サブパッケージのサブパッケージ、みたいにこまかく切っていくことはあまりない。
  * リポジトリ一個一個を小さく保つ

* Go っぽい感じだとあんまり分けない？
* microservice だと、microservice 同士で重複した処理が出てきたりする。
  * ops を助ける、logic を助ける共通パッケージが存在する。
  * logic は共有するとお互いに影響が及んでしまうのがキツイ。

* package 名がかぶりだすとつらい...

tenntenn
* internal package ？やめた。
* private とかにしとけばいざというときに使える。

# テスト周り

goapptest つらい・・・？

songmu さん
* 最初は標準。そのうち testify 。
* mysql のテストに使うフレームワーク。lestrat さんの。

kaneshin さん
* CI 周りはツラくて常に戦っている。テスト全消化で 30 分かかったりしている。ツラミ。
  * DB 周りのテストは消したい。モック使いたい。
  * GAE にデプロイするときは、全て Pure Go で動くように設計している。テストしやすいように。

deeet さん
* フレームワーク使わない派。フレームワークは mini DSL みたいなものだと思っていて、それを覚えるのはつらい。
* DB 周りのテストは、interface を使ってモックする。
* 依存している部分を interface で分ける。

* var hogehoge = func ... という感じで動的に関数を変えるスタイルもテストに役立つ。

songmu さん
* DB のテストはモックせずに実際に DB を立ててやるべき派。
  * ロジック外の部分。設定ファイルの関係で実際に DB に入らなかったりすることも起こる。
  * testmysqld

* Circle CI が遅くてちょっと…

# デプロイまでのフロート工夫している点。CIとか。

kaneshin さん
* ansible。dynamic inventry。

## go のビルドが遅くなる理由

* import が煩雑である
* 依存が連なっている場合、フルビルドがかかってしまう場合。
* C言語の include と同じような。

# pprof を本番で使っている？モニタリングやチューニングは？

大谷さん
* pprof は本番では使ってない
* モニタリングは zabbix で監視。プロセスが落ちたら復活させたり。
* チューニング。文字列を + で繋がない。とか。

松本さん
* pprof ではなく、golangstatsapihandler。
* datadoc でリソース監視。プロセスが落ちたらすぐ再起動するようになっている。
* 個のチューニングではなく、横に並べられる設計でスケールできるようにしておく。金の弾丸。

songmuさん
* goroutine のリーク

# 今ここがリファクタリングしたい。Goのここがイマイチだった。

松本さん
* template...



