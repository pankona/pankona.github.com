---
layout: post
title: "Linux で 無線LAN の USB ドングルを使う"
date: 2016-11-14 20:14:02 +0900
comments: true
categories: ArchLinux
---

Linux と銘打っておりますが、Manjro で試しています。
本記事は Linux で 無線LAN のドングルを使えるようにした備忘録です。

## 使ったドングル二種

訳あって二種類のドングルを使いました。いずれも I-O DATA 製。

* WN-AC433UM
* WN-G150UMK

## WN-AC433UM 編

とりあえずぶっ挿してみたところ、無線LAN デバイスとしては認識されなかった。
つまりデフォルトの Manjro には WN-AC433UM のドライバが入っていなかったということ。
ドライバを入れていく。

### WN-AC433UM は rtl8192eu というドライバで動いた

rtl8192eu というドライバは `yaourt rtl8192eu` で一応インストールされるのであるが、
それだけだと WN-AC433UM は認識されなかった。

WN-AC433UM は、idVendor が 04BB、idProduct が 0959 であるが、
`yaourt rtl8192eu` でインストールされるドライバではこれを認識するようになっていない。
(注: 2016.11.09 時点)

なので、上記 idVendor、idProduct 値を認識するようにソースコードを書き換えた上で、
ビルド・インストールする必要がある。ソースコードは以下から入手できる。

[Mange/rtl8192eu-linux-driver - GitHub](https://github.com/Mange/rtl8192eu-linux-driver)
なお、リビジョンは `f016814` を使った。

os_dep/linux/usb_intf.c に、以下のように追記する。
(注: 妥当か不明だがとりあえず以下の書き換えでうまくいった)

```
diff --git a/os_dep/linux/usb_intf.c b/os_dep/linux/usb_intf.c
index 5a62f24..7138a26 100644
--- a/os_dep/linux/usb_intf.c
+++ b/os_dep/linux/usb_intf.c
@@ -220,6 +220,8 @@ static struct usb_device_id rtw_usb_id_tbl[] ={
        {USB_DEVICE(0x2357, 0x0109),.driver_info = RTL8192E}, /* TP-Link - Cameo */
        /*=== PLANEX ===========*/
        {USB_DEVICE(0x2019, 0xab33),.driver_info = RTL8192E}, /* PLANEX - GW-300S Katana */
+       /*=== I-O DATA ===========*/
+       {USB_DEVICE(0x04bb, 0x0959),.driver_info = RTL8192E}, /* I-O DATA */
 #endif
 
 #ifdef CONFIG_RTL8723B
```

ビルドし、インストールする。

```
$ cd rtl8192eu-linux-driver
$ make
$ sudo make install
```

再起動すると、無線LAN ドングルを NIC として認識するようになった。

## WN-G150UMK 編

上記 WN-AC433UM を認識させるにあたって散々ドライバをインストールしたせいなのであろうが、
こちらは挿しただけで認識されてしまった。

### WN-G150UMK は rtl8192cu というドライバで動いている模様

もしかしたらドライバをインストールする必要があるかもしれないのでメモしておくと、
WN-G150UMK は rtl8192cu というドライバで動いている模様。`lshw` コマンドで確認した。

## ちなみに、WN-AC433UM は 5 GHz にしか対応していない

WN-AC433UM は 5GHz 帯「のみ」に対応しており、
つまり 2.4 GHz 帯を用いる無線機器とは接続ができない。スキャンしても発見すらしてくれない。
2.4 GHz っていうのはたとえば Android 5.0 以前の Android 端末のテザリングであったり、
ちょっと古めのルーターだったりが該当する。

完全に自分の見落としであるのだが、我が家の装備はことごとく 2.4 GHz 帯を扱うモノばかりだったので、
つまりせっかく頑張って WN-AC433UM を Linux に認識させたのであるが、日の目を見なかったのである…。
悲しい。そんなわけで WN-G150UMK を書い直したが、こちらは快調に動いてます。ナイス。

## 参考リンク

* [WN-AC433UMシリーズ - I-O DATA](http://www.iodata.jp/product/network/adp/wn-ac433um/)
* [WN-G150UMK - I-O DATA](http://www.iodata.jp/lib/product/w/4078.htm)
