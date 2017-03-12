---
layout: post
title: "golang.tokyo#4@eureka"
date: 2017-03-01 19:31:27 +0900
comments: true
categories: golang
---


今回のテーマは concurrency

# Concurrency for distributed Web crawlers by 末田さん

Fuller, Inc.
@puhitaku 

* AppStore と Google Play、欲しい情報をクロールするやつ

* シングルドメインだが対象となるアプリが多い (100k以上)
    * 同一IPからあんまりひどいことするとバンされたりする。
    * とはいえ24時間以内にクロールする必要がある。

## Informant

* Commander と Crawler
    * AWS EC2 Container Service
    * 一日30弱くらいのインスタンスを立ち上げて並列でクローリングする

* 1アプリあたりのクロール時間が見積もれないと困る
    * 一個あたりのクロールを goroutine で行う
    * 規定時間よりはみ出ても、次のタスクをスタートさせる。シーケンシャルではない。

* Slack bot として動く一面も。クローラーの状態を通知したり。
    * > status crawler ... 何度もポーリングする必要あってキツイ
    * command -> reply -> ユーザの interaction → bot がメッセージを edit
    * メッセージひとつにつき一対の Event Channel と Reaction Channel

* 落とし穴シリーズ
    * TCPコネクションを使い果たす問題
    * make(chan int, 100) みたく書いて Channel が保持する値の数を制限できる


# Goのスケジューラー実装とハマりポイント by niconegoto さん

LT。

## Goroutine の実装デザイン

* runtime を読む。
    * M ... Machine
    * G ... Goroutine
    * P ... Processor

## スケジューラーのハマりどころ

* コンテキストスイッチを考慮する必要がある
* Morsing's Blog

# Ridge a framework like GAE/Go on AWS by fujiwara さん

面白法人カヤック

* API Gateway
* AWS Lambda
* APEX
* Go のアプリケーションを Lambda の上で動かせる

* Ridge の性能評価

* AWS lambda 上で HTTP Server を動かす

# ライブコーディング by kaneshin さん

* tail コマンドを作る


# 嫁に怒られずに Go を書く技術 by teitei_tk

* LINE に天気予報だったりを投稿する
* Let's encrypt も使える

# Gogland by Sergey Ignatov さん




