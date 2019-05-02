---
title: "golang.tokyo #23 @ DeNA"
date: 2019-04-24T14:52:59+09:00
draft: false
---

2019 年 4 月 19 日 (金) に行われた golang.tokyo #23 (@DeNA) に参加ました。

イベントページはココ
<a class="embedly-card" data-card-controls="0" href="https://golangtokyo.connpass.com/event/126673/">golang.tokyo #23 (2019/04/19 19:10〜)</a>

<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

ツイッターはハッシュタグ「#golangtokyo」で検索すると、当日の実況ツイートの様子が分かります。
[ツイッター検索 (#golangtokyo since:2019-04-19 until: 2019-04-23)](https://twitter.com/search?f=tweets&q=%23golangtokyo%20since%3A2019-04-19%20until%3A2019-04-23&src=typd)

<div style="margin-bottom:24px">
  <a href=/images/golang.tokyo-23/03.jpg><img src=/images/golang.tokyo-23/03.jpg /></a>
  <div class="caption">会場ではベイスターズ的アルコール飲料が振る舞われました</div>
</div>

<div style="margin-bottom:24px">
  <a href=/images/golang.tokyo-23/02.jpg><img src=/images/golang.tokyo-23/02.jpg /></a>
  <div class="caption">軽食 (ベイスターズ的アルコール飲料に合う) も振る舞われました</div>
</div>

<div style="margin-bottom:24px">
  <a href=/images/golang.tokyo-23/01.jpg><img src=/images/golang.tokyo-23/01.jpg /></a>
  <div class="caption">golang.tokyo #23 開幕</div>
</div>

今回のテーマは「これから Go を始める人に知ってほしいこと」。
(実際に用いられた資料はイベントページを参照されたし)

当日使われた全ての資料のいくらかはまだ connpass のイベントページに載っていないようなので、一応本記事でもリストアップしておきます。
(以下、登壇順)

- セッション
  - [絶対に分かるポインタ](https://docs.google.com/presentation/d/1u93oMe7QForbqrCwGE2lHbu99t4I9_m5IzfeYETD7BU/edit#slide=id.p) by [tenntenn](https://twitter.com/tenntenn) さん
  - [Go をはじめるにあたって知っておいてほしいツール](https://speakerdeck.com/mom0tomo/golang-tokyo-go-tools) by [mom0tomo](https://twitter.com/mom0tomo) さん
  - [Go をはじめるにあたって知っておいてほしいツールやテスト](https://speakerdeck.com/mishirakawa/golang-dot-tokyo-number-23) by [micchie](https://twitter.com/micchiebear) さん
  - [Delve を用いたデバッグ & pprof を用いたプロファイリング](https://speakerdeck.com/xruins/delvewoyong-itadebatugu-and-pprofwoyong-itapurohuairingu) by [C_Ruins](https://twitter.com/C_Ruins) さん
- ライトニングトーク
  - [GoDoc と TDD にダイブして脱新人を始められる？話](https://speakerdeck.com/shoheshohe/godoctotddnidaibusitaratuo-xin-ren-woshi-merareru-hua) by [PGShohei](https://twitter.com/PGShohei) さん
  - [Go らしさと go generate](https://speakerdeck.com/horiryota/gorasisatogo-generate) by [hori_ryota](https://twitter.com/hori_ryota) さん
  - [GoRelaesr: Release and Distribute Go Application](https://speakerdeck.com/micnncim/goreleaser-release-and-distribute-go-application) by [micnncim](https://twitter.com/micnncim) さん

DeNA のイベントスペースらしきところでの開催であり、100 人弱くらいは集まっていたんではなかろうか。

golang.tokyo は今回で 23 回目。いつも定員オーバーになるくらいの人気な勉強会です。
今回も 74 の参加枠に対して 124 もの応募があった様子。人気。とても人気。

だので普通に参加しようと思ったら概ねの場合は抽選になってしまいますが、「ブログ枠」という「イベントの様子をブログにしたためてくれるなら参加していいよ」枠が存在します。
私もしばしばこれで参加しています。この枠だと早いもの勝ち、かつ何故か人気がない (いつもだいたい空いている) ので、参加したいが抽選にあぶれたくない人はトライしてみるのも良いのではないかと思います。

さて勉強会の様子。
今回は「これから Go を始める人に知っておいてほしいこと」ということで、セッションの内容はどちらかと言うと基礎的な内容でした。
Go の初学者の方にはもちろん有用であると思いますし、Go をやりこんでいる人にとっても諸々再確認できて非常に有意義な会だったと感じました。

前半のツール紹介は、主に Go 公式から提供されているツール類の紹介、ならびに使い方の説明でしたが、このツール類の充実っぷりは Go の特徴かと思っています。
便利ツールの諸々が野良の OSS じゃなくて公式から提供されているっていうのは安心感あるよね！ということで、知っておいてほしいツール類、必見です。

ライトニングトーク一発目の PGShohei さんは、今回が人生で初めてのライトニングトークだったとのこと。
初めてとは思えない発表クオリティにびびりつつ、その挑戦していく心意気には目頭が熱くなる思いでありました。
今回で 23 回目を数える golang.tokyo ですが、常連もいつつ、一方で新しいひともいつつ、という感じで広く門戸が開かれていると感じた会でした。

そんな golang.tokyo ですが、次回開催 (#24) が既に告知されています (2019/05/02 現在、まだ募集を開始していません) 。
<a class="embedly-card" data-card-controls="0" href="https://golangtokyo.connpass.com/event/129067/">golang.tokyo #24 (2019/05/20 19:10〜)</a>

次回は Go Conference 2019 に参加できなかった勢が主なターゲット (いわゆる RejectCon) であるようなので、また濃い話が聞けるのではないかと思います。楽しみですね！
参加者募集開始のアナウンスなどは [golang.tokyo 公式ツイッターアカウント](https://twitter.com/golangtokyo) をウォッチしていれば良いと思います。

最後に、ブログ枠なのにブログ書くの遅くなってほんとすんません...！イベントから二週間くらい経っちゃってますな…。
ちなみに次回の golang.tokyo #24 では「ツイッター実況枠」というのが設けられたようなので (その代わりブログ枠はなくなった) 、ツイッターの腕に覚えのある方はトライしてみてもいいんじゃないかなと思います。
