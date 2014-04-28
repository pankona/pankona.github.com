---
layout: post
title: "Pygmentsがエラーを吐きやがるので修正"
date: 2014-04-28 21:15:16 +0900
comments: true
categories: "Octopressカスタマイズ"
---

Octopressのカスタマイズを続けていく。

## Fenced Code Block がうまく表示されない

具体的にどのようにうまく表示されないかというと、

{% codeblock %}
{% raw %}
{% hogehoge %}
{% endraw %}
{% endcodeblock %}

といった表記。％で囲まれてる部分も Fenced Code Block を使って表示してもらいたいところであったが、<br>
コメントとしてみなされてしまっているようで、表示してもらえないという感じに。

結果として、

{% codeblock %}
{% raw %}
{\% codeblock %}
{\% raw %}
{% hogehoge %}
{\% endraw %}
{\% endcodeblock %}
{% endraw %}
{% endcodeblock %}


というので書くことができた。raw ~ endraw というのを使う。<br>
ただ、↑に書いている通り、ネストさせることができなかったのでバックスラッシュ突っ込んでお茶を濁した。。<br>
ネストさせるのはどうやればいいのかな？

## Fenced Code Block にファイル名が表示できない

Fenced Code Block を書くときに、↓のような書き方をするとコードブロックにちょっとした注釈が出る。

`{% raw %}{% codeblock about.html %}{% endraw %}`<br>

出るという触れ込みだったのだが、なかなかどうして出なかった。

結論からすると、これはうちのArchlinuxがpython3を使おうとしているためだった。<br>
PygmentsというやつがPython2.7を求めているところを、違うバージョンのPythonが使われちゃって失敗してた感じ。

修正方法は以下のページを参考にしました。というかそのまま使わせていただきました。多謝。
[Arch Linux, Octopress, and misbehaving Pygments - Nonsense By Me](http://www.nonsenseby.me/blog/2013/04/13/arch-linux/)


