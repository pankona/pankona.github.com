---
layout: post
title: "golang.tokyo #2@はてな"
date: 2016-12-12 19:24:17 +0900
comments: true
categories: golang
---

2016.12.12 に表参道のはてなさんにて、golang.tokyo #2 が行われました。

[golang.tokyo #2 - connpass](https://golangtokyo.connpass.com/event/44807/)

今回もまたブログ枠にて参加させていただきましたので、
その内容をレポートしていきます。

発表内容の詳細はスライド (上記 connpass のページから辿れます) を参照いただくのが一番良いと思います。
本記事ではその他、イベントの雰囲気や私の感想を主にお伝えできればいいかなと思っています。
それでは行きます。

---

今回の golang.tokyo は 2 回目の開催。
今後も色々目論まれているようです。楽しみ。

![golang.tokyo-2](/images/golang.tokyo-2/02.jpg)
図1. golang.tokyo について

golang.tokyo 2 回目のテーマは **「テスト」** について。

---

# テストしやすいGoコードのデザイン by deeeet さん

<a class="embedly-card" data-card-key="ee29ed4b275e459483a608ca67084559" data-card-controls="0" data-card-type="article-full" href="https://talks.godoc.org/github.com/tcnksm/talks/2016/12/golang-tokyo/golang-tokyo.slide#1">テストしやすいGoコードのデザイン</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>
(↑のカードをクリックでスライドに飛びます。)

![golang.tokyo-2](/images/golang.tokyo-2/07.jpg)
図2. 発表中の deeeet さん。

以下、印象に残ったところを抜粋。

## deeeet さんはテストフレームワークを使わない派

テストのフレームワークは使わず、testing パッケージだけで十分であろうとの意見。
これは、フレームワークは「ミニDSL」であって、導入するひとはまだしも、
あとからプロジェクトに入ってくる人は学習する部分が増えてしんどくなってしまう、という一面があるからとのこと。
納得。

## テストしやすいコードとは

**「Table Driven Test」** がおすすめ。
* 入出力が理解しやすい
* テストケース追加が容易
* 「Table Driven Test に落とし込めるコード」は入出力が明確でテストしやすいコード

## テストしにくくなる要素とその対策

テストしにくくなるというのは「Table Driven Test」がやりにくくなる状況を指す。
→ 入力以外の要素が出力影響を及ぼしてしまう状況。

* グローバル変数 (暗黙の入力)
  * なるべく関数の引数に入れるようにしてテストしやすくする
  * もしくは「デフォルトの値」として **のみ** 使う
  * 変わらないかもしれない定数っぽい値もなるべく設定可能にする
  * 環境変数もグローバル変数と同じ
* ユーザーの入力 (コマンドを入力→期待通りに動いたか、のテスト)
  * 入力の受取に os.Stdin を暗黙的に使わず io.Reader を使い、テスト時に仮想的な入力を行えるようにする。
  * 入力に対する出力で、Table Driven にすることができるようになる。
* ファイル出力 (ファイル出力された内容が正しいかどうか、のテスト)
  * 実際に書いたあとに開き直して中身を確認するのでもテストは可能だが、大量にやろうと思うと遅くなってしまう。
  * 入力のときと考え方は同じで、io.Writer を出力先とし、テスト時はオンメモリのバッファに出力できるようにする。
  * バッファに出力された内容とその期待結果で、Table Driven することができるようになる。

# MacherelにおけるGoのエコシステムとかテストとか by Songmu さん

<a class="embedly-card" data-card-key="ee29ed4b275e459483a608ca67084559" data-card-controls="0" data-card-image="https://mackerel.io/files/images/brand-assets/screenshot-service.png" data-card-type="article-full" href="http://songmu.github.io/slides/golangtokyo-2/">MackerelにおけるGoのエコシステムとかテストとか</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>
(↑のカードをクリックでスライドに飛びます。)

![golang.tokyo-2](/images/golang.tokyo-2/09.jpg)
図3. 発表中の songmu さん

## Mackerel のエコシステム周りの話

* ソースをオープンにしてパッチ受け入れるようにした。
    * ホスト先は GitHub。contribute してもらいやすい。
    * pull request に対するレビュー体制、CI が必要。
    * Travis CI、Circle CI を使っている。CI の内容は以下のようなもの。
        * go vet、 golint go test
        * coverage 計測
        * cross build 可能か
* ちなみに Changelog はプルリクエストの情報から自動生成している。

## ミドルウェアのテスト

* 実際にテスト時に実行する
    * DB ならばモックせずに実際に DB を立ててデータを入れて確認をする、のような。
    * モックや interface でのテストでは気づけない部分もあるので、実際にやってテストする。

---

# 休憩

deeeet さん、songmu さんの発表のあと、いったん休憩に。
休憩ではピザとビールが振る舞われまして、はてなさんにスポンサーしていただいたとのこと。
ありがたくいただきました。

![golang.tokyo-2](/images/golang.tokyo-2/11_rotated.jpg)
図4. ピザとビールをはてなさんから振る舞っていただく。

![golang.tokyo-2](/images/golang.tokyo-2/12.jpg)
図5. 会場遠景。芝生です。

![golang.tokyo-2](/images/golang.tokyo-2/13.jpg)
図6. deeeet さんにむらがる Gophers (私もこのあとむらがりました) 。


勉強会の真ん中にこういう親睦会的なノリの時間が設けられるのは珍しいかな？
なんだか新鮮でした。参加者の方とも少しだけお話できたりしました。
勉強会終わってからの親睦会だと参加できないケースが多い私のようなものにとっては、会の真ん中にこういうのやってもらうのもいいかもしれない。

---

# ここから LT コーナー

ピザとビールで温まってきたところで LT 開始。

## timakin さん

<a class="embedly-card" data-card-key="ee29ed4b275e459483a608ca67084559" data-card-controls="0" href="https://speakerdeck.com/timakin/plain-db-import-with-go">Plain db import with Go</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

* [timakin/gopli](https://github.com/timakin/gopli)
  * 開発環境を本番環境に近づけるやつ。本番データをローカルに簡単にもってくる。

## osamingo さん

<a class="embedly-card" data-card-key="ee29ed4b275e459483a608ca67084559" data-card-controls="0" href="https://speakerdeck.com/osamingo/go-deshi-meru-json-rpc-ru-men">Go で始める JSON-RPC 入門</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

* JSON-RPC！

## KazuhiraTogo さん


<a class="embedly-card" data-card-key="ee29ed4b275e459483a608ca67084559" data-card-controls="0" href="https://speakerdeck.com/ktogo/continuous-deployment-with-go-on-aws-ecs">Continuous Deployment with Go on AWS ECS</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

* デプロイをとことん自動化した話。
* 本番とローカルで同じ環境を → Docker を使う。
* Circle CI 上の docker は Ubuntu。本番は Alpine。環境の違いが問題に。 → Docker on Docker にして解決した。

---

以上の内容でした。せめて雰囲気くらい伝わればいいですが。
いずれの発表もとても内容が濃くて、勉強になりっぱなしでした。感謝。
ひとまず Table Driven Test ですかね。取り入れてなかったのでやってみようか等と思い。

感謝といえば、運営サイドのこと。
ほぼトラブルなしでスムーズに進んだのは、十分に準備してくれていたということだと思います。
だいたいマイクの電池が切れたりスライドがうまく映らなかったり、そういうの対策しようがなくてしょうがないところもあるんですが、
今回に関してはそういうのほぼほぼなくて、というかマイクの音量とか超ちょうど良くて、本当に細かい配慮を感じました。多謝。

次回もまた来年に予定されているようです。楽しみにしています！

