---
layout: post
title: "RaspberryPiで動画を配信しながら写真も撮る"
date: 2014-06-10 21:49:47 +0900
comments: true
categories: "RaspberryPi"
---

Raspberry Pi＋カメラモジュールを使って、
- 映像をWebページで配信しつつ。
- いま写してる絵を保存する（写真を撮るみたいな）。写真を撮るボタンもWebページに備える。
- 撮った写真はRaspberry Piにとりあえず保存しておいて、Webページ越しに確認できる。
というのをやってみた。
例によっていくつか躓いた点があるので、備忘録的に記しておく。

### raspistillでの静止画撮影とmjpg-streamerでの動画配信は同時に行えない？

どうやらそのようである。最初は、
「Webページ上にボタンを用意し、押されたら `raspistill` コマンドを発行する。」というやり方でやろうと思ったので当てが外れた感じ。
mjpg-streamerで動画を配信する状態になっている状態でraspistillコマンドを実行すると、エラーが吐かれてしまってうまくいかない。
mjpg-streamerにカメラデバイスを専有されてしまっているとか、そういう雰囲気でうまくいかないんだろうと予想。

### mjpg-streamerのsnapshot機能を使う

ではどうするかと言うと、mjpg-streamerには静止画を撮影する機能があるので、これを使ってみた。
[mjpg-streamerのプロジェクトのページ](https://code.google.com/p/mjpg-streamer/)に少しサンプルがあって、例えば、mjpg-streamerを動作させている状態でもって、
`http://[Raspberry PiのIPアドレス]:8080/?action=stream` というURLにアクセスすれば動画配信になり、
`http://[Raspberry PiのIPアドレス]:8080/?action=snapshot` というURLにアクセスすれば、静止画の撮影になる。
これらは、同時に行うことができる。つまり、これをうまく使えば動画を配信しながら静止画の撮影ができるのでは、と。

### wgetで画像を保存する

Webページ上にボタンを用意しておくところまでは同じで、ボタンが押されたら `raspistill` の代わりに、`wget` を発行する。
例） `wget -O /tmp/picture.jpg http://[Raspberry PiのIPアドレス]:8080/?action=snapshot`
上記の例では、/tmp/picture.jpgという名前でmjpg-streamerが出力している動画のスナップショットが保存される。
なので一応、動画配信しながら写真を撮る、という目的は達成できた。

できた、が、、、
動画配信中の画像をそのまま静止画にするだけなので、例えば静止画の画質を動画のものより良くする、とか、画像サイズを変更する、アス比を変更する、とかできない。
あくまで動画を一枚切り取っただけ、という感じ。まあ及第点か。。

### 撮った画像を確認するためにRailsアプリを作った

Raspberry PiでRailsなんてどうなのか。でもちょっと作ってみた。
目下作り途中だが。とりあえず動いてるのを見るのは楽しい。
https://github.com/pankona/raspi_camera_server

* あらかじめmjpg-streamerを起動した状態で、上記Railsアプリを動かす
* Railsアプリに何かからアクセスすると、動画が配信されている状態を確認できる
* 動画をクリックすると、スナップショットが保存される。
* 保存されたスナップショットは、動画下部に小さく表示される。

みたいなもの。テスト書いたりして改善していこう。。
