---
title: "golang.tokyo #14@メルカリ"
date: 2018-04-16T19:32:07+09:00
---

[golang.tokyo #14](https://golangtokyo.connpass.com/event/82723/) に参加してきたのでその内容メモ。
発表内容は以下。

- ホリネズミでもわかる Goroutine 入門 by [@inukirom](https://twitter.com/inukirom) さん
- チャネルのしくみ by [@knsh14](https://twitter.com/knsh14) さん
- ライトニングトーク 3 つ
  - vgo の話 by [@tanksuzuki](https://twitter.com/tanksuzuki) さん
  - プロダクションに Go を適用した話 by [@kurikazu](https://twitter.com/kurikazu) さん
  - linter を作る話

例によって軽食 (と言いつつかなり十分な量の食事が) 提供されており、ありがたくいただきました…！
ありがとうございました。ごちそうさまでした。

## ホリネズミでもわかる Goroutine 入門 by [@inukirom](https://twitter.com/inukirom) さん

<div style="max-width: 800px">
<script async class="speakerdeck-embed" data-id="5611568f65044914bb63fb0d787e0852" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>
</div>

<div style="margin-bottom:24px">
  <a href=/images/golang.tokyo-14/05.jpg><img src=/images/golang.tokyo-14/resized_05.jpg /></a>
  <div class="caption">inukirom さん発表の様子。とても丁寧でわかりやすかった。</div>
</div>

### goroutine と chan の基本的な使い方

goroutine と defer と panic を組み合わせて使う場合に注意すべき点があり、
たとえば以下のような場合、A 内で張った defer は呼び出されない**場合がある**。
(スライド内では"呼び出されない"と書かれているが、その限りではなさそうな)

```go
func A() {
    defer func(){}()
    go B()
}

func B() {
    panic("panic!!")
}
```

状況としては、

- `A()` が終わるよりも先に `B()` 内の `panic` が先に実行されたときは、`A()` 内の `defer` は呼び出されないまま終わる。
- `panic` よりも `A()` が終了するほうが先なのであれば、`defer` は実行される。

### channel

channel については以下のような話題がとりあげられた。

- close は結構デリケート (使い方を誤るとすぐに動かなくなる) なので注意
- RW、R only、W only という属性を持たせられる
- select. default で non-blocking にできる

ところで、channel は close しないでほっとくような例もよく見るのであれが、close しなくて良いのだろうか？

[golang-nuts でのやりとり](https://groups.google.com/forum/#!msg/golang-nuts/pZwdYRGxCIk/qpbHxRRPJdUJ) を見るにつけては、 使われなくなった channel は GC の対象になるため、あえて明示的に close する必要はないと言っている気がする。 channel を close すると受け手側にお知らせがいくので、どうやらそういう目的で使うらしい。

### wait 処理

goroutine の終了を待ち合わせする例の紹介。

- channel で待つ
  - 単なるお知らせであってお知らせ内容に意味がないのであれば、`struct{}{}` を使うのがメモリ効率が良い。
- sync.WaitGroup
  - `sync.WaitGroup` で、複数の goroutine を待ち合わせしやすくなる
  - `sync.WaitGroup` にエラー処理を生やしたみたいな `errgroup` なんかもある

### for ループと goroutine

for 文の中で goroutine 立てる例。よくある罠。

- 引数に渡して何とかする例
- 競合の解決
  - 直列でええやん、という場合もある
  - 排他制御に `sync.Mutex` 使う例。`RWMutex` もあるぞ
  - `sync/atomic` というパッケージもあるぞ

### goroutine のリーク

- goroutine の中でブロックしちゃうと goroutine がリークする
  - `context.Context` 等を用いると goroutine を終わらせる処理を書きやすい

### 便利ツールの紹介

- gotrace
  - goroutine と channel のやりとりを可視化できるぞ…！
  - docker image を使って動かしている

## チャネルのしくみ by [@knsh14](https://twitter.com/knsh14) さん

<div style="max-width: 800px">
<script async class="speakerdeck-embed" data-id="3ca3b188d9904775b4281cfee7018c27" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>
</div>

<div style="margin-bottom:24px">
  <a href=/images/golang.tokyo-14/03.jpg><img src=/images/golang.tokyo-14/resized_03.jpg /></a>
  <div class="caption">knsh14 さん発表の様子。シュラスコと寿司で例えていく。</div>
</div>

以下、LT

## vgo by [@tanksuzuki](https://twitter.com/tanksuzuki) さん

<div style="max-width: 800px">
<script async class="speakerdeck-embed" data-id="08cee61b8c56450d8ef618b378fcd6a0" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>
</div>

<div style="margin-bottom:24px">
  <a href=/images/golang.tokyo-14/02.jpg><img src=/images/golang.tokyo-14/resized_02.jpg /></a>
  <div class="caption">tanksuzuki さん発表の様子。GOPATH なくなるのは胸熱。</div>
</div>

vgo に関してはまだ使うのしんどい一面もあるものの、GOPATH、vendor が不要になるみたいな、Go を紹介するときに割と不評を買うところが改善されていくわけであり、今後に大いに期待である。

## プロダクションに Go を適用した話 by [@kurikazu](https://twitter.com/kurikazu) さん

<iframe src="//www.slideshare.net/slideshow/embed_code/key/lyY1i4CNbWM6jP" width="595" height="520" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen></iframe><div style="margin-bottom:5px"></div></iframe>

<div style="margin-bottom:24px">
  <a href=/images/golang.tokyo-14/04.jpg><img src=/images/golang.tokyo-14/resized_04.jpg /></a>
  <div class="caption">kurikazu さん発表の様子。Go 導入してハッピーなのは良いね！</div>
</div>

## linter を作る話 by [@dice_zu](https://twitter.com/dice_zu) さん

<a href="https://daisuzu.github.io/golang-tokyo-14/#1"><img src=/images/golang.tokyo-14/linter_by_dice_zu.jpg /></a>

<div style="margin-bottom:24px">
  <a href=/images/golang.tokyo-14/01.jpg><img src=/images/golang.tokyo-14/resized_01.jpg /></a>
  <div class="caption">dice_zu さん発表の様子。lint を比較的容易に自作できるのも Go の良いところか。</div>
</div>

プロジェクト独自のコーディングルールとかがあるのであれば、チームで lint を作って運用するのもありかもしれない。
個人的には named return value 禁止とかやりたいところであるが…？
