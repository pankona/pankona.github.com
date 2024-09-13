---
title: "GNOMEアプリ上で日本語入力できなくなったときの対処メモ"
date: 2016-12-14 11:12:31 +0900
comments: true
categories: [ArchLinux]
---

何が原因かハッキリしていないが、Linux をアップデート (パッケージの更新という意味) したときに
日本語が入力できなくなることがあった。

起きたこととしては、

- firefox 上では日本語入力可能 (direct input と日本語のトグル可能) 。
- Slack、chromium の上では日本語入力できない (direct input のみ可能) 。

環境は、

- Manjaro Linux (2016年12月あたり)
- fcitx を使用
- 日本語入力は mozc

方々ググって対処法を見つけたのでメモ。

## dconf Editor で設定を確認し、必要に応じて修正する

dconf Editor を開き、以下の設定を確認する。

- `/org/gnome/settings-daemon/plugins/xsettings/overrides` を参照する
- 値に `{'Gtk/IMModule': <'fcitx'>}` が入っているかどうか

コマンドラインから確認する場合は以下のように入力する。

```console
$ gsettings get org.gnome.settings-daemon.plugins.xsettings overrides
# (期待される出力) {'Gtk/IMModule': <'fcitx'>}
```

入ってなかったら、上記の値をコピペして設定する。
コマンドラインから設定する場合は以下のように入力する。

```console
$ gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "{'Gtk/IMModule':<'fcitx'>}"
```

当方の環境ではこれで日本語入力ができる状態になった。

## 参考サイト

- [Fcitx - ArchWiki (日本語版)](https://wiki.archlinuxjp.org/index.php/Fcitx#Gnome-Shell)
  - 「Ctrl+Space が GTK のプログラムで機能しない」の項を参照。
