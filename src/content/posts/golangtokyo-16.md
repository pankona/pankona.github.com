---
title: "golang.tokyo #16 @メルペイ"
date: 2018-07-13T19:15:16+09:00
---

[golang.tokyo #16 @メルペイ](https://golangtokyo.connpass.com/event/92225/)に参加。
本日は wasm がメインテーマ。発表者と資料は末尾に記載。

## そもそも wasm (WebAssembly) とは何か

以下は公式サイト。webassembly.org。
<a class="embedly-card" data-card-controls="0" href="https://webassembly.org/">WebAssembly</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

公式ページからの説明を引用すると以下のように書かれている。

*WebAssembly (abbreviated Wasm) is a binary instruction format for a stack-based virtual machine. Wasm is designed as a portable target for compilation of high-level languages like C/C++/Rust, enabling deployment on the web for client and server applications.*

C/C++/Rust 等で作ったバイナリをウェブブラウザ上で動かすための規格、くらいに捉えれば良かろうか。
公式を含む各所の記事をあたってみると、wasm の存在意義としては基本的には JavaScript から比較しての軽量化、高速化である模様。

## Go の wasm サポート

Go 言語も wasm へのビルド (トランスパイル) を Go 1.11 からサポートする予定であり、2018/07 現在は tip (Go の master のさきっちょ) を使うことで機能を試すことができる。
ちなみに Go 1.11 は、2018/08 にリリース予定。

## Go から wasm をビルドしてみる

たとえば以下のいわゆるハローワールド的なコードも wasm 向けにビルドできるようになる。

```
package main

import "fmt"

func main() {
    fmt.Println("Hello world!")
}
```

wasm 向けのビルドは以下のようなコマンドで行う。
(上記のソースが main.go として存在していると仮定)

```
$ GOOS=js GOARCH=wasm go build -o hello.wasm main.go
```

## 生成した wasm の動作確認まで

動作を確認するためにはもういくつかファイルが必要であり、Go のリポジトリからコピーしてくる必要がある。
GitHub に curl を飛ばしても取得できる。

ビルドと必要なファイルを揃える処理を一式 Makefile で書くと以下のような感じになる。

```
WASM = test.wasm
HTML = wasm_exec.html
JS   = wasm_exec.js
CLEAN_TARGET = $(WASM) $(HTML) $(JS)

all: $(WASM) $(HTML) $(JS)

$(WASM):
	GOOS=js GOARCH=wasm go build -o test.wasm main.go

$(HTML):
	curl -sO https://raw.githubusercontent.com/golang/go/master/misc/wasm/wasm_exec.html

$(JS):
	curl -sO https://raw.githubusercontent.com/golang/go/master/misc/wasm/wasm_exec.js

clean:
	rm -f $(CLEAN_TARGET)
```

一式そろうと以下のようになる。

```
$ ls
main.go  Makefile  server.go  test.wasm  wasm_exec.html  wasm_exec.js
```

この状態で wasm_exec.html を何らかの HTTP Server でサーブすると、なんとなく Console に Hello world 的な文字がでることが確認できる。
ちなみに file:/// で wasm_exec.html をサーブしても正しく動作しない場合があるようで、これは Chrome が file スキームで読み込んだ HTML ファイルだと JavaScript を実行してくれないためである模様。

上記までを一式納めたものは以下のリポジトリに置いておいた。
https://github.com/pankona/go-wasm-test

## 各セッションを聞いて

golang.tokyo#16 の各セッションを聞いての留意点としては、

* ベンチマークをとると、Go を JS にトランスパイルする GopherJS のほうがパフォーマンスが出る。wasm の最適化は今後の課題 (Go 1.12 以降？)
  * Chrome で動かす JS がやたら速いという一面も
* Empscripten (C++ から wasm を作るやつ) が比較的速い
* Go から作った wasm はまだバイナリサイズが大きい (2MB〜) という面があり、この点も今後の最適化が待たれるところ

## 色々まだまだな Go の wasm サポートとはいえ

ベンチマーク、バイナリサイズなどはまだ改善の余地があるとはいえ、超絶お手軽なクロスコンパイルは快適そのもの。
まだ出てきたばかり (出てきてすらいないか) なので、今後に大いに期待である。

以下、各セッションの資料を記載。

## (Session1) WebAssemblyとGoの対応状況について by [tenntenn](https://www.twitter.com/tenntenn) さん

* (TODO: 2018/07/17現在、発表資料がへのリンクが見当たらないので、後々更新)

* goroutine と channel には対応。wasm にマルチスレッドの機能が入るらしい。
* [https://tip.golang.org/pkg/syscall/js](syscall/js) を使う

## (Session2) GopherJS vs GOARCH=wasm by [hajimehoshi](https://www.twitter.com/hajimehoshi) さん

<a class="embedly-card" data-card-controls="0" href="https://docs.google.com/presentation/d/e/2PACX-1vQLOcSY-SpdWedMT48QFZ8f9T_XojfqUOCgMg4jqIz8cJjFIJhHm98gHKVyMaboqGpsXCfedplT-lmp/pub?start=false&loop=false&delayms=3000#slide=id.p">GopherJS vs GOARCH=wasm</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

以下、ライトニングトーク。

## (LT1) Go で社内向け管理画面を楽に作る方法 by [yudppp](https://www.twitter.com/yudppp) さん

<a class="embedly-card" data-card-controls="0" href="https://speakerdeck.com/yudppp/godeshe-nei-xiang-keguan-li-hua-mian-wole-nizuo-rufang-fa">Goで社内向け管理画面を楽に作る方法</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

* Go 歴 4 年の方。
* Viron を使って自社向けサービスの管理画面を自動生成する話。

## (LT2) Go のスライス容量拡張量がどのように決まるのか by [kaznishi1246](https://www.twitter.com/kaznishi1246) さん

<a class="embedly-card" data-card-controls="0" href="https://speakerdeck.com/kaznishi/180713-lt">Goのスライス容量拡張量がどのように決まるのか追った / 180713 LT</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

* Go 歴 1 ヶ月の方とのこと。1 ヶ月で LT しにくるの強い。
* メモリ確保量によってクラス分けされている。
* TCMalloc がメモリ確保量を切り上げる動作をする。

## (LT3) Go言語の正規表現に後読みを実装した話 by [さっき作った](https://www.twitter.com/make_now_just) さん

<a class="embedly-card" data-card-controls="0" href="https://slides.com/makenowjust/regexp-lookbehind-in-golang#/">Go言語の正規表現に後読みを実装した話</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

* いまのところまだマージされていないが、上記は既に実装して Gerrit にてレビュー中。
* マージされたら嬉しいね！

