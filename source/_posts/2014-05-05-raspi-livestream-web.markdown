---
layout: post
title: "Raspberry Pi + カメラモジュール + Webで配信"
date: 2014-05-05 23:38:52 +0900
comments: true
categories: "RaspberryPi"
---

Raspberry Piにカメラモジュールを接続し、映像をWebで配信させてみた。
いろいろ悩んだ点もあったので、やり方の結論をメモしておく。
ちなみに、Raspberry PiにはArch Linux (ARM版) を載せている。

## 良さそうな例

参考にしたウェブサイトは↓。結論からするとここだけでOKだった。
https://github.com/jacksonliam/mjpg-streamer

## 上記のリポジトリの情報を元にやったこと

### mjpg-streamerのインストール。
上記のリポジトリからソースコードをもってきてビルド。ビルド方法も上記のリポジトリのREADMEに記載されている。
pacmanであったりyaourtで取得できるmjpg-streamerのパッケージは使わない。それらはinput_raspicam.soを作ってくれないため。

### 超簡単にhtmlを書く。

下記のような。とりあえずサンプルなので、簡単に。。
書いたHTMLは、任意の場所におく。ここではひとまず、`~/www/index.html`として置いたとする。

```html
<html>
  <body>
    <h1>Raspberry Pi</h1>
    <img src="/?action=stream">
  </body>
</html>
```

### 配信するコマンドを実行する。

このコマンドも件のリポジトリに記載されているが、一応。
ライブラリ（.so）へのパスが通ってなかったら、LD_LIBRARY_PATHを設定してライブラリへのパスを通すか、もしくはライブラリをフルパスで指定する。

`mjpg_streamer -o "output_http.so -w ./www" -i "input_raspicam.so -x 1280 -y 720 -fps 15 -ex night"`

こんな感じに入力してやると、カメラが動き出して動画配信が始まる。
別のPC等からブラウザで、

`http://[Raspberry PiのIPアドレス]:8080/`

にアクセスしてあげると、カメラが写してる画像が配信されているのが確認できると思われる。
