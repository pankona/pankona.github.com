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

今回のテーマは **「テスト」** について。


## deeeet さん

* テストできないコードはない。問題はテストできない設計
* 良いコード＝テストできるコード

* Unit テストが最も大切

* 見てほしいところ
  * Advanced testing with Go by @mitchellh
  * Go best practices, six years in by @peterbourgon

* testing パッケージだけで十分
  * フレームワークは「ミニDSL」。最初の人は良いが、
  あとから入ってくる人は学習する部分が増えてしんどい。

### テストしやすいコードとは

* Table Driven Test
  * 入出力が理解しやすい
  * テストケース追加が容易

* 「Table Driven Test に落とし込めるコード」がテストしやすいコード
  * 入出力が明確

* テストしにくい場合
  * グローバル変数 (暗黙の入力)
    * 引数に入れるようにしてテストしやすくする
    * 「デフォルトの値」としてのみ使う
  * なるべく設定可能にする
    * 変わらないかもしれない値もなるべく設定可能にする
  * 環境変数もグローバル変数と同じ
* ユーザーの入力
  * os.Stdin を暗黙的に使わず、io.Reader を使う。

* テストしやすいデザインの指標

* 関数のテスト
  * void 的なやつはテストしにくい

* ファイル出力
  * io.Writer で書き出すと抽象化できる
* 標準出力／標準エラー出力
  * os.Stdout、os.Stderr が暗黙の出力先なので、io.Writer で切り替えできるようにする。
  * bytes.Buffer

* interface によるモック

* Gopherよ、明示的であれ

### Q&A

* main 関数のテスト？
* あとで！

* テストを書くタイミング？
* TDD はしない。まずざっと書いてから、あとで整理していくスタイル。


## 「Macherel における Go のエコシステムとかテストとか」 ... Songmu さん

### Mackerel のエコシステム周りの話

* ソースをオープンにしてパッチ受け入れ
* GitHub にホスト。contribute してもらいやすい
* pull request は放置していはいけない。レビュー体制、CI。
* Travis CI、Circle CI
* CI で
  * go vet golint
  * go test
  * coverage 計測
  * cross build 可能か
* golint に set_exit みたいので終了コード指定できる
* Travis に tag を git push させる
* Change log 自動生成も
* テストを回す前に goimports をかける
  * dragon-imports

### ミドルウェアのテスト

* 実際にテスト時に実行する (mock、interface でカバーしきれない部分もあるので)

### Q&A 

* Change Log 自動生成？
* ghch っていうのを使っている


## LT

### timakin さん

* [LT資料](https://t.co/7fJxiY5VlW)

* timakin/gopli
  * 開発環境を本番環境に近づける
  * 本番データをローカルに簡単にもってきたい
  * seed 作るのしんどい

### osamingo さん

* JSON_RPC

 * [LT資料](https://t.co/LOMW3vxrEW)

### kazuhira.togo @ LIG.ing

* CD の話

* 本番とサーバで同じ環境を → Docker を使う
  * EC2 コンテナサービス
* Circle CI 上の docker は Ubuntu。環境の違いが問題に。 
  * docker on docker にした
