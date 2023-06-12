---
title: "fiddle を使って Ruby から Go を呼ぶ"
date: 2020-07-23T00:54:06+09:00
categories: [Go, Ruby]
---

2020-07-22 に行われた「社内ゆるい Ruby LT 会」にて、「Ruby から Go を呼ぶ」というネタで話をした。

<!--more-->

資料を用意しないで、実際にコードを書いて実行する様を見てもらうという感じの発表形式をとったもので「残るもの」がない。だので、資料の代わりと言ってはあれだが何をどう話したかというのを記念に本記事に記しておく。

## fiddle

Ruby から Go を呼ぶと言っても色々やり方があり、たとえば、

- Go で作った実行バイナリを Ruby から `system` 的なもので呼び出す
- Go で作った HTTP Server を Ruby の HTTP Client を用いて呼び出す

みたいなのも広い意味では Ruby から Go を呼ぶのに該当しそうな気がする。
が、今回はもうちょっと泥っぽく、「Go で書いたソースコードを共有ライブラリ化したものを用いて、Ruby からそのライブラリに含まれている関数を呼び出す」という形式を披露した。役に立つかはさておき、一番映えそうだったからである。うふふ。

Ruby にはこういう「共有ライブラリを読み込むための機能」が標準で用意されていて、それが `fiddle` と呼ばれているやつである。
同じような機能を提供するライブラリとして `ffi` とかそういうのもあるけど、まあ「標準」という言葉に弱い僕であるので、とりあえず `fiddle` を試していくことにした。

## 何はともあれ Go で共有ライブラリを作る

まずは呼び出される側の共有ライブラリを作る作業を行った。
ソースコードは以下。`lib.go` というファイル名で保存した。

```go
package main

import "C"

//export Add
func Add(a, b int) int {
    return a + b
}

func main() {}
```

何かのチュートリアルに出てきそうな至極シンプルな足し算をする関数。
一応、普通の Go と違う点としては cgo のための諸々 (`import "C"` しているところと `export Add` というコメントを付与しているところ) が追記されていることかしら。

これを以下のコマンドでビルドする。

```sh
$ go build -buildmode=c-shared -o lib.so lib.go
```

すると、`lib.h` と `lib.so` が出力される (今回、ヘッダーは使わない)。

```sh
$ ls
go.mod  lib.go  lib.h  lib.so
```

## Ruby から読み込む

出力された `lib.so` を、Ruby のコード内から読み込む。
このような感じで `lib.so` をロードし、その中の `Add` 関数を `extern` を使って呼び出せる状態にしている。

```ruby
require 'fiddle/import'

module M
  extend Fiddle::Importer
  dlload 'lib.so'
  extern 'int Add(int, int)'
end

p M.Add(1, 3) # 実際に呼び出しているのはココ
```

実行結果は以下のようになる。期待通り。

```sh
$ ruby ./main.rb
4
```

晴れて Ruby から Go を呼び出すことができた。便利！

## ライトニングトークで触れなかった補足など

ライトニングトークでは、時間の都合上、上記の部分までの話しかしなかった (5 分という縛りだった) のだが、本手法は便利な話ばかりでもなくて不都合だとかやりにくいところだとかが色々ある。そもそも Ruby と Go に限らず、言語間バインディングなんて問題の巣窟になること請け合いであるというのが僕の印象であってだな。

上記のように `int` を使っている間は特に問題がないのだけれども、もう少し便利に使おうと思ったら他の型 (特に byte array みたいなものとか string) を使いたくなるのが人情かと思う。
実はこのへんを扱うのは割と面倒で、何が面倒って「メモリの確保と解放」をそれなりに意識してやる必要が出てくる。

例えば、Go から文字列を返してやろうと思ったら以下のようなコードになる。

```go
package main

import "C"

//export Fullname
func Fullname(firstname, lastname *C.char) *C.char {
    fullname := C.GoString(firstname) + " " + C.GoString(lastname)
    p := C.CString(fullname)
    return C.CString(firstname + lastname)
}

func main() {}
```

このコードをざっくり解説すると、

- `Fullname` 関数は、`lastname` と `firstname` を受け取って、連結したもの (つまり `fullname`) を返す関数。
- 引数、および戻り値の型で `string` を使うようなところでは、代わりに `*C.char` を使うようにしている。`string` を扱おうと思うと Ruby 側では構造体を扱う必要が出てきて少し面倒になってしまうので、生々しいが単なる `*char` を扱うほうが簡単になる (と思う)。
- `*C.char` はそのままでは Go の `string` として扱えないので、いったん `C.GoString` に食わせて `string` に変換している。
- `string` に対して一通りやりたい処理をやったあとに、`string` を戻り値の型である `*C.char` に変換する必要がある。
- `C.CString` に `string` を食わせると `*C.char` 型になって出てきてくれるのだが、`C.CString` を使って生成した文字列は「メモリ解放」をしなければならない。しないとメモリリークになってしまう。
- メモリ解放をして良いタイミングは Go 側からはわからないので、Ruby の側からメモリ解放のための関数を呼んであげる必要がある。

そこまでケアすると以下のような感じになる。

Go の側。メモリ解放のための関数を追加した。

```go
package main

import "C"

//export Fullname
func Fullname(firstname, lastname *C.char) *C.char {
    fullname := C.GoString(firstname) + " " + C.GoString(lastname)
    p := C.CString(fullname)

    return p
}

//export Free
func Free(p *C.char) {
    C.free(unsafe.Pointer(p))
}

func main() {}
```

Ruby の側。メモリ解放のための関数を呼び出すように変更。

```rb
require 'fiddle/import'

module M
  extend Fiddle::Importer
  dlload 'lib.so'
  extern 'char* Fullname(char* p0, char* p1)'
  extern 'void Free(char* p0)'
end

ptr = M.Fullname('pan', 'kona')

p ptr.to_s

M.Free(p)
```

実行結果は以下。

```sh
$ ruby ./main.rb
"pan kona"
```

おそらくこれでメモリリークはしない状態になっている、はず。

## つまり

言語間バインディングは用法と用量を守って使うのだ。

## 参考

- [cgo - The Go Programming Language](https://golang.org/cmd/cgo/)
- [library fiddle - Ruby 2.7.0 リファレンスマニュアル](https://docs.ruby-lang.org/ja/latest/library/fiddle.html)
