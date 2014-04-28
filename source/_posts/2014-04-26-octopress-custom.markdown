---
layout: post
title: "OctopressにGravatarの画像が出るようにしてみた"
date: 2014-04-26 20:19:19 +0900
comments: true
categories: "Octopressカスタマイズ"
---

引き続きOctopressをカスタマイズしていく。

### サイドバーにGravatarの画像を出すように

京都で食べた抹茶パンケーキ（←旨い）の画像を載せるように。
自分のブログ感が出て良い。

以下のGravatarプラグインを使わせてもらいました。多謝。

[joet3ch/gravatar-octopress](https://github.com/joet3ch/gravatar-octopress)

↑を導入すると、Gravatarの画像をimgタグ的にひっぱってこれるようになるので、
それを参考にしつつ、souce/_include/custom/asides/about.html を編集してった感じ。

about.html はこんな感じに。

{% codeblock about.html %}
{% raw %}
<section>
  <h1>About Me</h1>
  {% if site.gravatar_email %}
    <img src="{% gravatar_image %}" alt="Gravatar of {{site.author}}" title="Gravatar of {{ site.author }}" align="left" style="margin-right:10px;" />
  {% endif %}
  Arch Linux on Vaio Pro 13で日々遊んでます。Octopressはvimで編集。武蔵野線ユーザ。一応、ソフトウェアエンジニア。
  <br clear="left">
</section>
{% endraw %}
{% endcodeblock %}

### CommentをかけるようにDisqusを設定

各ポストにコメントがかけるような感じにしてみた。いかにもブラグらしい。<br>
設定方法をざっくり書いておくと、

<span>
1. Disqusのアカウントを作り、ブログサイトに関する情報を登録するとshort nameが取得できる
2. _config.ymlのdisqus_short_nameに、↑で取得したshort nameを設定する
</span>


次はテーマを変更してみようかな。デフォルトでもそこそこかっこいいが。
