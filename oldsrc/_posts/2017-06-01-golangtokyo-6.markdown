---
layout: post
title: "golang.tokyo#6@DeNA"
date: 2017-06-01 19:34:21 +0900
comments: true
categories: golang 
---

2017.06.01 に DeNA さんにて、golang.tokyo #6 が行われました。

[golang.tokyo #6 - connpass](https://golangtokyo.connpass.com/event/57168/)

開幕は DeNA の方のお話だったんですが、何やら DeNA では Go エンジニアを色々募集しているようです！
サーバーのみならず、色んなフィールドで Go を使っているとのことです。

![golang.tokyo-6](/images/golang.tokyo-6/3.jpg)
今日も大勢の方が参加されております。

![golang.tokyo-6](/images/golang.tokyo-6/4.jpg)
出遅れて私はありつけなかったですが、開幕前からお寿司が振る舞われていました！

![golang.tokyo-6](/images/golang.tokyo-6/5.jpg)
私はおビールいただきました。

# Gopher Fest 2017 に参加した話 by tenntenn さん

* mercari テックブログ にて既にまとめられている tenntenn さんの記事もあります。
(http://tech.mercari.com/entry/gopherfest2017_report)

今日は参加レポートをしてくれました。
主に 2017年8月上旬あたりにリリースされそうな Go 1.9 の話。

スライドはこちら。
https://www.slideshare.net/takuyaueda967/gopher-fest-2017

以下、話の中で気になって点のピックアップ。

## 言語仕様の拡張 - Alias の追加

型にエイリアスが張れるようになるとのこと。
以下のような書き方ができるようになる。
```
type Applicant = http.Client
```

この場合、Applicant と http.Client は等価。

いつこれが役立つかというと、型をリネームするようなリファクタリングを行うとき。
以下の手法だとうまく行かない。

(パターン1) 新しい型を作って順次移行する場合

```
type Applicant Client
```

* Applicant は Client に生えていたメソッドを引き継げない。
* キャストは可能。

(パターン2) 埋め込みを使う場合

```
type Applicant struct { Client }
```

* Applicant は Client に生えていたメソッドを引き継げる
* しかしキャストはできない

型エイリアスを用いると、

* 両者等価なのでキャスト不要で交換可能
* メソッドもそのまま使える、が、エイリアス側に生やすことはできない

#### 参考

* 安全にリファクタリングするには？  
[codebase refactoring (with help from Go) by rsc](https://talks.golang.org/2016/refactor.article)

## ライブラリへの変更

### ビット演算ライブラリ

http://tip.golang.org/pkg/math/bits/
各種ビット演算用の某がそろっております。

### sync.Map

スレッドセーフなマップが追加に。
しかも make しないで 0 値のまま使えるらしく便利。

### os.Exec 環境変数をコードで上書きできるように

環境変数で指定されている値をコード上で上書きできなかった。
Go 1.9 からは後勝ち。より直感的な動作になる。コードで上書きできるように！


などなど。
スライドには出ていませんでしたが、個人的には mips32 向けの softfloat サポートがどうなったか気になります。Go 1.9 でサポートされるんだったような。

次は DeNA の方。

# 初めて Golang で大規模 Microservices を作り得た教訓 by Yuichi MURATA

DeNA の方です。
AndApp を作ったときに得られた教訓の話。

Gin と Echo をさまよった話でさまざま苦労なさったそうな。
失敗談をメインに話してくださったので、そういうのは割と貴重と思います。

スライドはこちら。
https://www.slideshare.net/yuichi1004/golangtokyo-6-in-japanese

## 教訓1. Go でフレームワークに拘ることはない。

* Gin を使って開発を始める。
* ちょっと困ったことがあって、一部で別のフレームワーク (Echo) を使い始める
* 両対応しつつ、また Echo 自身の開発がホットなせいで設計がどんどん変わってしまう

というようなことで、聞いているだけでしんどい気持ちでいっぱいでしたが、
結論としては、フレームワークに頼らずに net/http 使っとくのが一番や、という話でした。
ツールに振り回されるとツライですね。納得。

## 教訓2. Interface を尊重する - エラーの型の話

独自エラー型と error インターフェースを混在させると起こり得る罠。
独自 error は nil 扱いされない問題。
素直に error インターフェースの利用に統一するべきだという結論。

エラーの種類によって分岐したいとき等、結構ひとによってやり方がまちまちだという気がするので、
なにがしかデファクトスタンダードなやり方が示されていると良い気がしますね。

ちなみに、自分が書くときの「エラーで分岐」については、
deeeet さんの [Golangのエラー処理とpkg/errors](http://deeeet.com/writing/2016/04/25/go-pkg-errors/) で記載されているやり方に従っている。

## regex compile / reflection の遅さ

JSON Schema でバリデーション。
OSS として扱った二種の速度の話。

* gojsonschema
  * validation のたびに parse & compile するので遅い
* go-jsval
  * こちらは速い

regex / reflection 等の処理は遅いので、使うときは意識しないといけない

## 結論

* Go の哲学。シンプルなアプローチを。
* 「コンパイルする言語だから速い」と過信せず、パフォーマンスに気を配ろう。

以下、LT。

# ゲーム開発で必要な by @konboi

カヤックの方。
[スライドはこちら](https://speakerdeck.com/konboi/gemukai-fa-nihaqian-kasenai-arewosiyututojian-ru)

## CSV の話

データの形によっては非常に見にくいCSV。
いい感じに整形してくれるツールを作った！
[csvviewer](github.com/Konboi/csviewer)

スターしておきました。

# Go code Review Comments を読もう by knsh14

KLabの方。スライドはこちら。
https://speakerdeck.com/knsh14/go-code-review-comment-wofan-yi-sitahua

こういう記事があって、Effective Go 簡易版というか、Go のお作法初級編みたく書かれている。
[Go Code review comments](https://github.com/golang/go/wiki/CodeReviewComments)

それを日本語訳した！
* [Qiita の記事はこちら](http://qiita.com/knsh14/items/8b73b31822c109d4c497)

初学者のみならず、ある程度経験がある人でも読んで損はないと思いました。
認識を改めるというかね。ちなみに社内勉強会で使わせていただきました、感謝！

# Scala から Go にきた話 by James さん

エウレカの方。
スライドは発見できませんでした…。

Scala が好きということは分かりました。
悲しいアリクイかわいい。

# Crypto in Go by suzuki kengo さん

マネーフォワードの方。

資料はこちら。アライさんですね。
https://paper.dropbox.com/doc/Crypto-in-Go-cWLX9XxHQm6bAPqrZYkjt

難しい。

# まとめ

ということで今回も参加させていただきました、ありがとうございました。
失敗談というかアンチパターンというか、そういう話が聞けたのは大きな収穫でした。

2017.06.15 現在、既に次の golang.tokyo が企画されています。
[golang.tokyo #7](https://techplay.jp/event/624712)
気になる方は要チェックです！

