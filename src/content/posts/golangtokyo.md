---
layout: post
title: "golang.tokyo #1@mercari"
date: 2016-10-25 19:38:13 +0900
comments: true
categories: [golang]
---

2016.10.25 に六本木の森タワーメルカリさんにて、golang.tokyo #1 が行われました。

[golang.tokyo #1 - connpass](http://golangtokyo.connpass.com/event/39965/)

以下に togetter まとまってます。
[メルカリ本社で開催されたGo言語勉強会 golang.tokyo #1 #golangtokyo - Togetterまとめ](http://togetter.com/li/1040839)

参加者の方のまとめです。きれいにまとまっていて読み応えあります。
[Hello Gophers, Hello Golang.tokyo #1 - 365 simple life - g.o.a.t](http://godgarden.goat.me/3Hf9qTNO)

本イベントにブログ枠にして参加させていただきましたので、
その内容をレポートしていきます。

![golang.tokyo-1](/images/golang.tokyo-1/06.jpg)
図1. 入り口にていただいたステッカー。にゃってとごっふぁーくん。かわゆし。

## どういう主旨のイベントかと言うと

いわゆる一般的な勉強会（？）でやるような、「数人の発表者が順繰りにスライドを用いて発表を行っていく」という体ではなく、パネルディスカッション形式。
事前に収集された質問に対して、パネラーの方々が体験談を踏まえて回答をしていく、というのが主な内容。
名だたる5名のパネラーさん達の詳細については、[connpass のイベントページ](http://golangtokyo.connpass.com/event/39965/)を参照いただきたい。

![golang.tokyo-1](/images/golang.tokyo-1/05.jpg)
図2. 司会の tenntenn さん。

![golang.tokyo-1](/images/golang.tokyo-1/09.jpg)
図3. 向かって左正面。Songmu さん、大谷さん、kaneshin さん。

![golang.tokyo-1](/images/golang.tokyo-1/02.jpg)
図4. 向かって右正面。y_matsuwitter さん、辻さん。

写真遠いし真っ黒やんけ。しかし顔で勉強会するわけじゃないということでご容赦いただければと思います。

ちなみに開始当初から軽食、おビールなんかも振る舞われており、20時前開始という、
おそらく夕飯食べてないであろう我々には、とても良い環境を提供いただいておりました。
メルカリさん、いつもありがとうございます。

## 本番中も質問が募集されていた

Google Apps のどの機能なのかちょっと失念してしまったのですが、
本番中も質問を次々ポストできる形式になっていて＋既存の質問に対してイイねが可能になっていて、
みんなが聞きたい質問が優先的に採用されてディスカッションされるというスキームでした。

あんまり見かけないやり方だなぁと思いつつ、視聴者参加型で面白い仕組みだと思いましたので、
今後もやってくれたらいいなー、と感想を残しておきます。

## そして本編 - 質問と回答集

前置きが長くなってしまいましたが、
ここからは実際どのような質問がされ、どのように回答がなされたのかを載せていきます。
※ 全部載せるとだだ長くなってしまうので、独断と偏見で端折りつつ、お送ります。

### Q. メンバーの Go の教育はどうしてますか？

Go に馴染みのないメンバーにどうやって Go を学んでもらうか？というトピック。

* 辻さん > 
    * [tour of go](https://tour.golang.org/welcome/1)、[effective go](https://golang.org/doc/effective_go.html) あたりから入ってもらう。
    * [初心者が見ると幸せになる場所　#golang](http://qiita.com/tenntenn/items/0e33a4959250d1a55045)
    * 標準ライブラリのコード読んだり
    * ハマりどころの勉強会をしたり
    * あとは実践あるのみでソースレビュー
        * 経験ある人をレビュアーにいれ、Go っぽくないコードを指摘したり

![golang.tokyo-1](/images/golang.tokyo-1/04.jpg)
図5. そしてディスカッションが始まった

### Q. IDEやデバッグはどうしているか

Go でデバッガといえば [delve](https://github.com/derekparker/delve) かと思ったが、思ったより使われていないのかなという印象。
ちょこちょこテスト書いて動かしていけば、それほど難儀なデバッグが必要になることも少ないっていうことかしら？

* songmu さん >
    * vim 使っている。メンバーが使っているのは結構バラバラ。
    * デバッグは主に print デバッグ。ちょっとコード書いてちょっとテスト書いて、みたいな。
* 大谷さん >
    * intellij idea。何人か vim。
    * デバッグは主に print デバッグ。実際に動かしながら。

### Q. コーディオング規約、レビューの指針、golint に従うか、など。

個人的には、従うと腹を決めて一度クリーンな状態になれば、あとはさほど苦ではないと思うが、はたして。

* 辻さん >
    * コーディング規約は [CodeReviewComment](https://github.com/golang/go/wiki/CodeReviewComments) を基準にしている。
    * 発火させるだけの単純なチャンネルには 空 struct を使う。
    * golint はベストエフォート。というのも、3rd party ツールがが生成するコードが golint に従ってない場合もあったりするようで…。
        * golint の対象を除外は grep -v で頑張る。
* songmu さん >
    * glint には従っている。従えば Go っぽい書き方ができてくると思う。

![golang.tokyo-1](/images/golang.tokyo-1/13.jpg)
図6.songmu さん回答中。
 
### Q. Webフレームワークとテンプレートエンジンは？ORMは？

* 辻さん >
    * Echo。パフォーマンス重視の選択。
    * テンプレートエンジンは...標準のを使うのは結構ツラかった。フロントエンドは Go では書いてない。
    * DB のラッパーは [squirrel](https://github.com/Masterminds/squirrel) を使っている。
* kaneshin さん >
    * 当初は [Revel](https://revel.github.io/) を使っていたが、重量級な感じだったのでとっぱらいたかった。
        * 後に [Gin](https://github.com/gin-gonic/gin) で置き換えた。
        * router に [gorrila/mux](https://github.com/gorilla/mux)。もしくは標準の http。
    * テンプレートエンジンは標準のがツライ。フロントエンドは SPA を JS で作っている。
    * ORM は [XORM](https://github.com/go-xorm/xorm)。 一部では [gorm](https://github.com/jinzhu/gorm)。

#### ところでフロントエンド事情は…

* Go のテンプレートはツライ。
* react とか angular とか使っちゃう。

みな口々に「Go のテンプレートはツライ」と言っていたのが印象的でした…。

### Q. エラー処理どうしてますか？pkg/errors？ panic は？

* tenntenn さん >
    * pkg/errors を主に使う。
* songmu さん > 
    * panic はなるべくしないように作る。
    * goroutine の中でのエラーは、[sync.ErrorGroup](https://godoc.org/golang.org/x/sync/errgroup)。

[sync.ErrorGroup](https://godoc.org/golang.org/x/sync/errgroup) の使い方について、
ちょうど近頃[類似トピックの記事 - sync.ErrGroupで複数のgoroutineを制御する](http://deeeet.com/writing/2016/10/12/errgroup/)をポストされていた deeeet さん (※ e は 4つ) からのコメント。

* [deeeet さん](https://twitter.com/deeeet?lang=ja) >
    * ErrorGroup は便利。たくさんの処理があって、一個でも失敗したらご破産にしたいときに使う。
* kaneshin さん >
    * error はエラーを上位レイヤーに伝搬させていく思想。
    * panic はしっかり使っていく派。起動直後に実行されて失敗したらどうにもならないものとかに対して。

![golang.tokyo-1](/images/golang.tokyo-1/08.jpg)
図7. deeeet さん (一番奥)。

### Q. Git に上がっているオススメの Go で書かれたものは？

* kaneshin さん >
    * [aws-sdk-go](https://github.com/aws/aws-sdk-go)。コードジェネレーション部が参考になる。
    * リクエストの作り方、リクエストのリトライの仕方。パッケージの構造なども。
    * [google-cloud-go](https://github.com/GoogleCloudPlatform/google-cloud-go) も参考になる。
    * [go-github](https://github.com/google/go-github) も。
    * [kaneshin/gate](https://github.com/kaneshin/gate)。Makefile の使い方がポイント。rake task 的な。

### Q. ロガーどうしている？

ロガーは [logrus](https://github.com/Sirupsen/logrus) が定番といった空気でした。

* 辻さん >
    * [logrus](https://github.com/Sirupsen/logrus)。
    * [zap](https://github.com/uber-go/zap) というのもある。使い勝手が特殊な感じだが高速らしい。
* 大谷さん >
    * Web アプリではフレームワークのロガーをそのまま使う。
    * fluentd でひっかけて Big Query に投げる、等。

### Q. パッケージ分けどうしているか？パッケージ名、循環 import 問題は？

パッケージ分けは割と悩むポイントかと思いますが、はたして。

* 松本さん >
    * ひとつのサービス内のサブパッケージは2つか3つくらい。
        * 設計上のドメイン軸で切っていく。ニュース記事・ユーザー・...
        * サブパッケージのサブパッケージ、みたいにこまかく切っていくことはあまりない。
        * リポジトリ一個一個を小さく保つようにしている。
* tenntenn さん >
    * [internal package](https://blog.golang.org/go1.5) というのもあるが、使うのをやめた。
    * 別にそこまでしなくても、例えば private とかつけておいて区別さえできればよく、またこうやっとくといざというときにも使える。

あとは、以下のような意見も。

* Go っぽい感じを意識すると、あんまりパッケージを分けない？
* microservice だと、microservice 同士で重複した処理が出てきたりする。パッケージ化して、service 同士で共有するか？
    * ロジックを共有すると、変更がお互いに影響してしまうので留意が必要。

### Q. テスト周り

* songmu さん >
    * 最初は標準を使っていたが、そのうち [testify](https://github.com/stretchr/testify) を使うように。
    * lestrrat さんの mysql のテストに使うフレームワークを使ったりもしている。[lestrrat/go-test-mysqld](https://github.com/lestrrat/go-test-mysqld)。
* kaneshin さん >
    * CI 周りはツラくて常に戦っている。テスト全消化で 30 分かかったりしている。ツラミ。
        * 今の気持ちとしては、DB 周りのテストは消したい。モック使いたい。
        * GAE にデプロイするものは、全て Pure Go で動くように設計している。テストしやすいように。
* deeeet さん > 
    * フレームワーク使わない派。フレームワークは mini DSL みたいなものだと思っていて、それを覚えるのはつらい。新規メンバーをげんなりさせる原因。
    * DB 周りのテストは、interface を使ってモックする。依存している部分を interface で分ける。
    * 詳しくはここ → [Golangにおけるinterfaceをつかったテスト技法 | SOTA](http://deeeet.com/writing/2016/10/25/go-interface-testing/)
* songmu さん >
    * DB のテストはモックせずに実際に DB を立ててやるべき派。
    * ロジック外の部分の問題も留意するべき。設定ファイルの関係で実際に DB にデータが入らなかったりすることも起こる。

### Q. デプロイまでのフロート工夫している点。CIとか。

* kaneshin さん >
    * ansible。dynamic inventry を使っている。

#### ところで、Go のビルドが遅くなる理由

Go のビルドは一般的には早いと言われているが、遅いとしたらそれは何故かと言うと…？

* import が煩雑である。依存が連なっていて、フルビルドがかかってしまう場合。

これは例えば、A が B に依存していて、B が C に依存している、なんていうシチュエーションのとき、C を変更したら依存を遡って B も A もビルドが走ってしまう、ということが起こる模様。
ちょうど C言語の include と同じような感じかな。ヘッダー変えたら全ビルド走っちゃうみたいな。
個人的には Go でビルド速度にそれほど苦を感じたことはないが、とはいえ、留意されたしである。

### Q. pprof を本番で使っている？モニタリングやチューニングは？

* 大谷さん >
    * pprof は本番では使ってない
    * モニタリングは zabbix で監視。プロセスが落ちたら復活させたり。
    * チューニング面では、文字列を + で繋がない。とか。
* 松本さん >
    * pprof ではなく、[golang-stats-api-handler](https://github.com/fukata/golang-stats-api-handler) を使っている。
    * [datadog](https://www.datadoghq.com/) でリソース監視。プロセスが落ちたらすぐ再起動するようになっている。
    * 個のチューニングではなく、横に並べられる設計でスケールできるようにしておく。札束で殴る。金の弾丸！

## その他の質問

概ね、以上のトピックスでディスカッションが行われました。
他にも、回答は得られませんでしたが、

![golang.tokyo-1](/images/golang.tokyo-1/11.jpg)
図8. Go言語プログラマの給料はいかほどか…

なんていう質問も出たり。
ネタも挟みつつ、終始知見に溢れた有意義なディスカッションでありました。

## おわりに

運営の方々、登壇の方々、お疲れ様でした！

golang.tokyo #2 も計画されていると噂を聞きますので、
興味を持たれた方、チェックしてみてはいかがでしょうか。
Go 言語に興味さえあれば、参加して楽しいかと思います。

![golang.tokyo-1](/images/golang.tokyo-1/07.jpg)
図9. 戦利品としてTシャツいただきました！


