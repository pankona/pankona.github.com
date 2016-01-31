---
layout: post
title: "二本指スワイプに戻る／進むを割り当てる方法 for Firefox on Arch Linux"
date: 2014-09-15 00:30:08 +0900
comments: true
categories: "ArchLinux"
---

ブラウザはFirefoxを好んで使っている。
VimperatorとかPentadactylがあるおかげである。

いままで放置していた問題があって、それは二本指スワイプの挙動設定。

二本指で左右にスワイプしたときに、ヒストリーバック・ヒストリーフォワード、
いわゆる「戻る」「進む」をやってほしいんだけど、これの設定がいまいちわからず、放置していた。
ようやく設定方法がわかったので記しておく。そっこー忘れそうであるので。

ちなみに、「on Arch Linux」と題しているが、おそらくArchに限らないLinux全般の話ではないかと想像。
UbuntuとArch Linux、どちらのFirefoxでもデフォルト設定では横方向二本指スワイプが仕事をしてくれなかったので。

では、以下設定手順。

## synclientの確認と設定

そもそもタッチパッドのドライバーレベルで横方向スクロールが無効になっている可能性がある。というかなってた。
なので、確認方法と設定変更方法。

#### synclientコマンドを打って水平方向二本指スクロールの設定を確認する

以下のコマンドで現在の設定を確認できる。

`$ synclient`

ずらずらっと出てくる内容のうち、`HorizTwoFingerScroll` が確認対象の項目。
値が「0」だったら無効になっている。有効にしない限り、いくら頑張って横スワイプしても効かない。

#### synclientコマンドで水平方向二本指スクロールを有効にする

上の確認で有効だったらここは飛ばしてOK。無効だった場合、有効にするのは以下のコマンド。

`$ synclient HorizTwoFingerScroll=1`

synclientのほうはこれでOK。

## Firefoxの設定

さらにFirefoxの設定を変えてやる必要がある。
設定内容は[Touchpad Synaptics - Arch Linux Wiki](https://wiki.archlinux.org/index.php/Touchpad_Synaptics)、Firefox 17.0 and laterの項を参考にした。

about:configを開く。設定内容は以下。

#### マウスホイールのアクションを変更する

`mousewheel.default.action.override_x = 2` とした。
あんまりよく調べていないが、「2」が戻るアクションに対応している数字らしい。

#### スワイプ方向を逆にする

デフォルトでは、左スワイプが「進む」、右スワイプが「戻る」になっている。
逆な気がする。設定してこれを逆転させる。

`mousewheel.default.delta_multiplier_x = -100` とした。

#### 感度を落とす

デフォルトではものすごく感度がよい。
良すぎてしまって縦スワイプがちょっと横にぶれただけで戻ったり進んだりする。
やりにくいので感度を落とす。

`mousewheel.default.delta_multiplier_x = -10` とした。

## ここまでやって

とりあえず望む形（二本指で左スワイプで戻る、右スワイプで進む）に設定できた。結構ハードルあった。。
ちなみにこれ、Mac OS向けFirefoxならデフォルトの挙動な模様。何の差なのか。。。

