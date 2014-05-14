---
layout: post
title: "Arch LinuxとWindows8.1をデュアルブートにしたときの備忘録"
date: 2014-05-14 17:59:10 +0900
comments: true
categories: "ArchLinux"
---

## このポストは

Windows8.1に対してWindows Updateしたところ、何だかわからないがデュアルブートしなくなって焦ったため、
直し方というか、そもそもどうやってデュアルブートにしているかをメモしておくための記事。

### 件のPCについて

以下のようなPCと、その中身の構成にしている。

-- PC本体：Vaio Pro 13
-- OS：Arch LinuxとWindows8.1のデュアルブート

### デュアルブートのためにしたこと - まずは普通にArch Linuxをインストール

* Arch Linux起動のためのUSBメモリを作成。ここはWindowsを使う。

[USB Installation Media（日本語） - Arch LinuxのWiki](https://wiki.archlinux.org/index.php/USB_Installation_Media_(%E6%97%A5%E6%9C%AC%E8%AA%9E)) なんかが参考になる。

* Windowsを使ってLinux向けのパーティションを切る。

「管理」を使ってやる。[ブート パーティンションを作成する - Microsoftのページ](http://windows.microsoft.com/ja-jp/windows/create-boot-partition#1TC=windows-7)等が参考になる。
とにかく何か領域が空いていればいい。うちの構成では180GB程度確保した。
少なくとも30GBくらいいるかな？

* Arch Linux起動用のUSBを挿した状態でPCを起動し、USBからのブートを行う。

あとは↑で作ったパーティションにArch Linuxをインストールしていく。詳しくはやはりArch LinuxのWiki参照。
-- パーティションのフォーマット。割り当て可能領域はすべて割り当て。EFIパーティションにする必要はない。普通ので。
-- /mnt にフォーマットしたパーティションをマウント。`mount /dev/sda5 /mnt` ← うちの環境の場合。
-- chrootする。`arch-chroot /mnt` で。 
-- Arch Linuxのインストール。 `pacman -S base base-devel` とかやる。
-- genfstab とかそういったことをこまごま行う。
-- ブートローダのインストール。ブートローダにはgummibootを採用した。

```
mount /dev/sda2 /boot/EFI
cd /boot/EFI
gummiboot install
```

ここまでで勝手にデュアルブートしてくれたら嬉しかったが、そうはいかなかった（本来はこれだけでOKらしい）。
Vaioのせいなのか、Windowsのせいなのか。。

### デュアルブートのためにしたこと - 無理やりgummibootを使わせる

上記までで何が起きるかというと、、、
どうやら、せっかくgummibootで設定したブートの設定がPC起動時になかったことにされてしまう模様。
つまりWindowsが問答無用で起動される状態に戻ってしまう。VaioのせいなのかWindowsのせいなのか。。。

この点をちゃんと解決するのは諦めました。
諦めて、Windowsの起動に使われるファイルをgummibootのものと置き換えることでデュアルブートを実現。。
一応、やれればいいや、ということで。

* 先ほどのUSBからArch Linuxを起動し、無理やりgummibootを使わせるようにしにいく

-- まず、EFIのパーティションをマウントする。

```
mount /dev/sda2 /mnt/boot/EFI
```

-- Windows起動用のファイルとgummiboot起動用のファイルを置き換える。

--- Windows起動用のファイル ... /boot/EFI/Microsoft/boot/bootmgrfw.efi
--- gummiboot起動用のファイル ... /boot/EFI/gummiboot/gummibootx64.efi

上記のWindows起動用のファイルを、gummiboot起動用のファイルで上書きしてやると、、、
次回のPC起動時には、OS選択の画面が表示されるはず。上書きする前にバックアップしてあげてね。。。

### Windowsアップデートのときに、bootmgrfw.efiが更新されちゃうことがあるっぽい

だのでWindowsアップデートでデュアルブートができなくなったりするんだろう。
デュアルブートできなくなったら、いちいちgummibootx64.efiをWindows起動用のファイルに上書きしてやる必要がある。

## これでWindowsアップデートも怖くない！
