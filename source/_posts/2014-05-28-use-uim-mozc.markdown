---
layout: post
title: "日本語入力のための設定メモ for Arch Linux"
date: 2014-05-28 07:49:23 +0900
comments: true
categories: "ArchLinux"
---

IMはずっとibusを使ってきたのだが、なかなか設定に融通が効かないというか、なんというか。
具体的な要望としては、

- mozcを使いたい
- Alt + Space でIMEを切り替えたい（Direct Inputと日本語入力をトグルする）

という二点なのだが、後者の「Alt + Space」というキーバインドを設定する方法がわからず。。。
きっとやり方があるというか、いままでごまかしごまかしやってきたのだが、
ついに気持ち悪さが先に立って、「やめてやるわ！」となったところ。

で、IMとしてUIMを使ってみた。uim-mozc。
そしたらいともたやすく Alt + Space でのトグルが設定できちゃったもんだから拍子抜けというか。
はじめからこれ使ってれば良かったね！しばらくこれでいきます。uim-mozc。

備忘録的に、設定方法のメモ。
Arch Linux向けです。

## 基本的にはWiki参照

ブログに書いた内容というのはいずれ時代遅れになるので、、、
やはり、Arch Wikiの[uim-mozcの設定方法](https://wiki.archlinux.org/index.php/Input_Japanese_using_uim_(%E6%97%A5%E6%9C%AC%E8%AA%9E))を参照するのが確実。
うちもこれでいけた。

## インストールしたパッケージ

- uim
- uim-mozc

## 設定箇所

- .xinitrc の記載

.xinitrcに以下を追記。uimを使う設定ですな。

```bash .xinitrc
# uim
export GTK_IM_MODULE='uim'
export QT_IM_MODULE='uim'
uim-xim &
export XMODIFIERS='@im=uim'
```

## uimの設定

`uim-pref-gtk`で設定画面を出し、色々設定する。

- 「Global settings」の設定。

  -- Specify Default IMにチェックを入れる。
  -- Default input method を Mozc にする。

- 「Mozc」の設定。

  -- Default Input modeはDirect Inputに。
  -- ついでにVIM協調モードも有効にしておく。

- 「Mozc key bindings」の設定。

  -- [Mozc] on/off、両方に"\<Alt\>space"を設定。

### ここまでで

Alt + Space でDirect Inputと日本語入力がトグルできるようになった。
チャンスがあれば、他のIMも試してみよっかな。

