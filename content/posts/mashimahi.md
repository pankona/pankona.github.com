---
title: "強いパスワードのためのフレーズジェネレータを作ってみた"
date: 2018-06-23T17:00:42+09:00
---

ふと思い立って、フレーズジェネレータなるものを作ってみた。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">こないだ作ってみた「強そうなパスフレーズ/パスワード生成器 (PhraGen)」に CSS をあててちょっとオシャレにしといたぞ。無駄に日本語への自動翻訳もつけておきたかったが、翻訳部分は無料ではいまいち達成できなそうかなー。<a href="https://t.co/tThQl1mfSe">https://t.co/tThQl1mfSe</a></p>&mdash; パン粉 (@pankona) <a href="https://twitter.com/pankona/status/1010435240714633216?ref_src=twsrc%5Etfw">2018年6月23日</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

GAE/Go で作成。[ココ](https://strongest-mashimashi.appspot.com/) にホスティング。PhraGen (ふらげん) と命名。

## これは何か

どこかで聞いた話であるが、いわゆる「強いパスワードというのはどうやって生成するのが良いのか」ということを考えた時に、
ひとつの手法として**「英語の辞書からランダムで 3 単語ひっぱってきてつなげるのが良い」**というのがあると小耳に挟んだわけである。

なるほどなるほど、ということで、では試しに作ってみようということで作ってみたのがこれである。

## ちょっとした工夫

完全にランダムな単語をチョイスしたほうがパスワード的には強いのだろうけど、きっとそれは覚えにくいフレーズになってしまうと思われる。
ということで、ちょっとでも覚えやすいフレーズを生成するために、完全にランダムなチョイスではなく**「形容詞＋形容詞＋名詞」**の順で現れるフレーズを生成するようにしてみた。
**Super Great Goalkeeper** 的なものが生成されることをイメージしている。

## ジェネレータのしくみなど

### Oxford Dictionaries API

そもそも英語の辞書のデータをどのように扱えば良いのか。出どころはどこか、ということを探していると以下を見つけた。

<a class="embedly-card" data-card-controls="0" href="https://developer.oxforddictionaries.com/">Oxford Dictionaries API</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

これは英語辞書で有名な Oxford が提供してくれている (と思われる)、Web API である。
REST API の形をしていて (なんと Swagger の定義までついている)、ドキュメントの記載通りに叩くことで単語とその意味などを得ることができる。
形容詞で、"super で始まる" 5字以上の単語、みたいなクエリでワードリストを取得できるような機能が提供されている。

これを利用しようということで、まずは提供されている swagger の定義をありがたくお借りしてクライアントライブラリを生成した。
以下のリポジトリに置いておいた。またいつか使うかもしれない。

<a class="embedly-card" data-card-controls="0" href="https://github.com/pankona/oxford-dict-api-client-go">pankona/oxford-dict-api-client-go</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

### レスポンス遅いけどキャッシュは規約違反

ただ、一回のクエリに数秒かかるようなところがあり、PhraGen の裏で動かすにはちょっとしんどい一面がある。
3 単語から構成されるフレーズを作るということは 3 回リクエストするということであり、つまり 1 フレーズ生成につき 5〜6 秒は待たされてしまう。

問い合わせてみたところ、規約上、フリーのプランでは Oxford Dictionaries API が吐き出す結果をキャッシュしておくことは禁止とのこと。
お金を払えば制限つきでキャッシュしておけるということで、検討されたしとのお達しであった。うーむ…。
※ この点については、近日中にバイオレーションのない形に変更予定。

### ホスティングは GAE、バックエンドは Go

ジェネレータは GAE/Go で作った。ソースコードは以下のリポジトリに格納。

<a class="embedly-card" data-card-controls="0" href="https://github.com/pankona/strongest-mashimashi">pankona/strongest-mashimashi</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

リポジトリ名に深い意味はなく、なんとなく語呂が良いのでつけておいた。ストロンゲストマシマシ。

### フロントエンドは色々

フロントエンド力がナメクジレベルのパン粉であるが、色々調べつつ、以下の技術要素の利用を試みている。
特に CSS フレームワーク Bulma のおかげで、PhraGen はまあまあしゃらくさい感じのキレイな見た目になったのではないかと思っている。

* TypeScript
* React
* CSS フレームワークとして Bulma

### 使えるのか

使えるかどうかよりもそもそも使わなそう。
でもせっかく作ったので、実際にパスワードの生成のために使ってみる所存。

