---
layout: post
title: "PiTFTをArch Linux on Raspberry Piで動かすのに苦戦"
date: 2014-07-17 21:11:11 +0900
comments: true
categories: "RaspberryPi"
---

**2014/07/23/Wed 追記**

以下のポストに誤りがあることがわかったので、訂正。
誤っている部分には打ち消し線を入れておく。

------

[PiTFT](http://www.adafruit.com/products/1601)を購入。
さっそくRaspberry Piで動かそうとしてみたところ、これがなかなかうまくいかず。
3日程粘ってようやく動いた。やり方を記載しておく。

Raspberry Piには、Arch Linuxが載っている前提です。

### 参考になるページ

[notroさんのfbtftに関するWiki](https://github.com/notro/fbtft/wiki)。本当に感謝。Great。
ただ、ここに書いてある手順を踏んだだけではうまく動かなかった。
以下、顛末と動かすまでの手順。

#### rpi-updateが使える状態にする

以下、Raspberry Pi上でのコマンド入力。
以下のコマンドでrpi-updateを取得＆実行可能権限付与。

`$ wget https://raw.github.com/Hexxeh/rpi-update/master/rpi-update`
`$ chmod +x ./rpi-update`

rpi-updateは適当な場所に移しておく。パスが通っているところに置いておくと便利。
以下、rpi-updateがある場所にパスが通っている前提で記載。

### rpi-updateを使ってKernelをアップデート

FBTFTドライバがビルトインされているとされるバージョンにしてみる。

`$ sudo -E REPO_URI=https://github.com/notro/rpi-firmware BRANCH=builtin rpi-update`

なんやかや起こったあと、リブート。

`$ sudo reboot`

これでFBTFTドライバが準備オッケーになっているはず、なのだが…？

### ~~fbtft_deviceがない~~

~~fbtft_deviceを有効にするために、modprobeしてみる。~~

`$ sudo modprobe fbtft_device name=adafruit22`

~~すると帰ってきた答えは、~~

`FATAL: Module fbtft_device not found.`

~~とのこと。実際に探してみたところ、fbtft_device.koというモジュールは存在していない様子。~~

----

**2014/07/23/Wed 訂正**

結論から言うと上記の挙動であっていた。
`BRANCH=builtin`を選択した場合はfbtft_deviceがloadableなモジュールとして現れない、
つまり modprobe で見つからないと言われるのは正しかった。

上記の状態で、あとは /boot/cmdline.txt に然るべき内容を追記するだけでOK。
その後PiTFTを接続し、Raspberry Piを再起動すれば画面に何か映るはず。

よって以下の手順はすべて無駄であるが、
以下の手順が誤りであることを示すために残しておく。。


以下、無駄な手順メモ。全く不要。

----

### ~~いろいろやってfbtft_deviceを用意する~~

~~fbtft_deviceを求めて色々さまよったところ、上述のKernelアップデートの際に、~~

`sudo REPO_URI=https://github.com/notro/rpi-firmware rpi-update`

~~とビルトインではなく、loadable moduleとしてfbtft_deviceが現れるやつをチョイスしてみたところ、~~
`sudo modprobe fbtft_device name=adafruit22`がnot foundではなく、別のエラーになった。
~~探してみたところ、実際にモジュールは存在した。ただし正常にmodprobeできていない。~~

~~FBTFTのモジュールは、~~
`/lib/modules/$(uname -r)/kernel/video/fbtft`
~~に置かれている。これをどこか別の場所にコピーしておく。後々使う。~~

### ~~rpi-updateを使ってFBTFTビルトインバージョンに戻す~~

~~上で一回やってるやつをやって、FBTFTビルトインバージョンのKernelに戻す。~~

`$ sudo -E REPO_URI=https://github.com/notro/rpi-firmware BRANCH=builtin rpi-update`
`$ sudo reboot`

### ~~戻したのち、コピーしておいたfbtftを所定の位置に戻す~~

`/lib/modules/$(uname -r)/kernel/video/fbtft`~~の位置に戻す。~~

### ~~depmodする。~~

`sudo depmod -a`

### ~~fbtft_deviceをmodprobeする~~

~~not foundとは言われなくなり、ちゃんとロードされる。はず。~~

### あとはnotroさんのところの手順に従う

/boot/cmdline.txtであるとか、もろもろ変更する。
PiTFTはきっと動き出す。

