---
title: "golang.tokyo #15@DeNA"
date: 2018-05-30T19:39:48+09:00
---


[golang.tokyo #15](https://golangtokyo.connpass.com/event/87064/)に参加してきた。
内容は以下。

* メインの30分セッションふたつ
  * Effective Streaming in Golang by [avvmoto](https://twitter.com/avvmoto) さん
  * 次世代のコンテナランタイム！？gVisorのコードを読みながら理解してみる by [niconegoto](https://twitter.com/niconegoto) さん
* ライトニングトークは発表予定の 2 人が都合が悪くなってしまったらしく、急遽代打を現地で 2 名補充

## Effective Streaming in Golang by [avvmoto](https://twitter.com/avvmoto) さん

<div style="max-width: 800px">
<script async class="speakerdeck-embed" data-id="3431ee80147b48b2beabf723612382e5" data-ratio="1.41436464088398" src="//speakerdeck.com/assets/embed.js"></script>
</div>

<div style="margin-bottom:24px">
  <a href=/images/golang.tokyo-15/10.jpg><img src=/images/golang.tokyo-15/resized_10.jpg /></a>
  <div class="caption">avvmoto さんの発表。io package を使いこなして無駄をなくそう！</div>
</div>

何かデータを読み込んでそれを引き回そうというときに、**読み取り時にメモリ上に確保し、 確保したメモリを引き回す**とやってしまうと、関数をまたぐたびにコピーが発生してしまう (もしくはポインタで渡していくか) みたいなことが起きがちである。
io.Reader interface を引き回すことで、**いざ実際に必要になった段で初めてメモリ上に読み込む**ような動作にでき、メモリ効率、処理速度の向上に寄与できるんじゃない、という話だったと理解した。

## 次世代のコンテナランタイム gVisor を理解する by [niconegoto](https://twitter.com/niconegoto) さん

<div style="max-width: 800px">
<script async class="speakerdeck-embed" data-id="648504c5f1724ee5b97d1f14ca12a4cb" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>
</div>

<div style="margin-bottom:24px">
  <a href=/images/golang.tokyo-15/08.jpg><img src=/images/golang.tokyo-15/resized_08.jpg /></a>
  <div class="caption">noconegoto さん。</div>
</div>

gVisor はよりセキュアにコンテナの仕組みを使おうということで出てきたプロダクトの模様。
Google においては、gVisor についていずれ論文で技術的な詳細をつまびらかにする予定があるらしく、出てきたら読んでみようかなと思う。
ちなみに、[gVisor のソースコード](https://github.com/google/gvisor)は既に20万行くらいになっているらしく、なかなかゴツいっすね…。

暫時休憩を挟み。

<div style="margin-bottom:24px">
  <a href=/images/golang.tokyo-15/03.jpg><img src=/images/golang.tokyo-15/resized_03.jpg /></a>
  <div class="caption">軽食のミニチキンカツサンド。本日も色々いただきました。ありがとうございました。</div>
</div>

以下、ライトニングトーク。

## LT by [@yoshi_xxxxxiiii](https://twitter.com/yoshi_xxxxxiiii) さん from Cluex

<div style="max-width: 800px">
<script async class="speakerdeck-embed" data-id="e4a3aaa06df042cbbcd90cd215ec858d" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>
</div>

<div style="margin-bottom:24px">
  <a href=/images/golang.tokyo-15/04.jpg><img src=/images/golang.tokyo-15/resized_04.jpg /></a>
  <div class="caption">yoshi_xxxxxiiii さん。アゴヒゲキンパツの二つ名があるとのこと。</div>
</div>

* 「mamanoko」「ままのて」というサービスを運営されているとのこと。
* せっかく実装したローディング画面について、サーバが JSON 返すの速くなりすぎてローディング画面が出ない、という苦情があったらしい。すごいね。

しばしば Rails と Go は比較に上がる気がする。Go に一部変えたら速くなりました！みたいな。
Rails だから遅いってこともないという認識だけど、速くしようと思ったら大変ってことなのかなー。

## LT by [@pospome](https://twitter.com/pospome) さん

* 急遽代打で登壇。
* 技術書典で golang.tokyo が出した本に寄稿した内容の紹介

## LT by [@karupanerura](https://twitter.com/karupanerura) さん

* こちらも急遽代打で登壇。
* 以下の記事について解説。
<a class="embedly-card" href="https://qiita.com/karupanerura/items/fa3b35dfdceb96730b03">Goで書いたMicroservicesな構成からWeb APIを叩くときに考えたこと - Qiita</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>


