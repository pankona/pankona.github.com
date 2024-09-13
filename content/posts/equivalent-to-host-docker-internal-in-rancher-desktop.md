---
title: "Rancher Desktop で host.docker.internal に当たるのは host.rancher-desktop.internal"
date: 2022-05-01T14:34:21+09:00
draft: false
categories: ["その他"]
---

どこにも書いてない気がしたのでひとまず備忘録として残しておく。Rancher Desktop で `host.docker.internal` みたいなことがしたいときは `host.rancher-desktop.internal` を使えばいい。

<!--more-->

## Rancher Desktop

Rancher Desktop というのがあり、これは自分の PC 上に k8s 環境を構築できるという代物。 必要な k8s manifest が揃っていれば割とサクッと自分の PC をノードに見立てて pod を生やすことができる。便利。

Rancher Desktop
https://rancherdesktop.io/

## pod 上からホストと通信したい

docker であれば container 内から `host.docker.internal` に対して通信することで container はホストマシンとやりとりすることができた。これは container 上の特定の通信をホストでプロキシしたい時などに便利だった。

Rancher Desktop においてこれと同等のことをしたい場合は `host.rancher-desktop.internal` を使えばいいようだ。ソースは Rancher Desktop の Slack チャンネル。Slack チャンネル内を `host.docker.internal` みたいな単語で検索していたら発見した。試したらちゃんと動くことを確認した。

## 補足

この情報は公式ドキュメントには載ってないような気がする (2022-04-28 時点)。自分のググり力の問題かもしれないが、ちょっとググッたくらいでは出てこなかった (どっかに書いてあったらすまぬ)。

2022-04-28 の時点では `host.rancher-desktop.internal` というアドレス指定が動作することを確認した。動作確認した環境は 2019 年の Mac Book Pro、Intel な CPU、OS は Monterey。あと Rancher Desktop の設定でコンテナランタイムに containerd を選択していた。使った Rancher Desktop は v1.3.0 だった。
