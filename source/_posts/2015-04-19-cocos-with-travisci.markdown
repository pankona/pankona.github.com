---
layout: post
title: "cocos2d-x + Travis CI"
date: 2015-04-19 11:26:14 +0900
comments: true
categories: "cocos2d-x"
---

引き続きcocos2d-xを使ってブロック崩しを作っている。
かれこれ２ヶ月あまりが経過した。ほぼ通勤時間でのみ作っている。

いまのところの作業の流れとしては、
* まずLinux向けにビルドして動作確認
* 問題なさそうであれば、Android向けのビルドを実施
* なんとかして実機にAPKを移し、インストールする

という手順なのであるが、実機へのデプロイがなかなか面倒である。
基本的に電車内なので、ケーブルをスマホとPCに繋いで〜、というひと手間がなかなか面倒である。
すると端末間のファイル共有だったり、原始的にメール越しにAPK共有、等があるが、、、やはり面倒である。

デプロイもっと楽にする手段としてDeployGateさんを使わせてもらうという手がある。
これを用いると、変更をコミットするとそれだけで最新版APKがメールで送られてくるっていうようになるようである。

なので今回はこれを導入してみることにした。流れは以下のような感じになる予定である。
* PC上にてcocos2d-xでアプリ作成。ソースをGithubにPush。
* Travis CIでビルド。
* ビルド成果物をTravis CIがDeployGateに送信。
* DeployGateがわしのスマホにメールを送信（APK添付）。

以下、長文。

## cocos2d-x + Travis CI

CI環境としてTravis CIをチョイスした。無料で使えるからである（Publicなリポジトリ限定かな）。
初のTravis CI利用ということもあり、なかなかに躓いたというか知らんことが多かったので、備忘録を残す。

### そもそもTravis CIに何をしてもらえるか

ちょいちょい試してみたところ、以下のような感じである。

* GithubへのPushをトリガーにして自動的にビルド実施。
  * ビルドに限らず、任意のScriptを実行可能。自動テストなんかも行うようにするとなお吉。
  * ビルド前処理、後処理、など、割と細かくステージ分けがされている。
* ビルド失敗、成功の旨をメールにて通知。
* masterだけでなく、他のブランチへのPushに対しても同様の処理をしてくれる。

ざっくりだがこんな感じだろうと。無料で使えるにしては十分かな。

### さっそく設定する

設定手順はこんな感じ。

1. Travis CIのWebサイトにて、監視してほしいリポジトリの設定をする。
1. リポジトリのトップに .travis.yml を置く。
1. あとはソースをプッシュするだけ。

(1)と(3)は別に問題ないと思われる。問題は(2)である。
以下、.travis.ymlの内容について書く。

### ビルドパスした .travis.yml はこれ

いかにもやっつけ感満載でありつつ、とりあえずビルドパスするところまでいけた。
記念に貼り付けておく。もしかして誰かの役に立つことも願いつつ。

```yml .travis.yml
language: android

# Handle git submodules yourself
git:
    submodules: false

install:
# NDK configuration
    - printenv
    - echo `pwd`
    - wget http://dl.google.com/android/ndk/android-ndk-r10d-linux-x86_64.bin
    - chmod a+x android-ndk-r10d-linux-x86_64.bin
    - ./android-ndk-r10d-linux-x86_64.bin -y | grep -v Extracting # because log will be too long!
    - export NDK_ROOT=`pwd`/android-ndk-r10d
    - echo $NDK_ROOT
    - export PATH=$PATH:$NDK_ROOT
    - echo $PATH

# Android SDK configuration
    - export ANDROID_SDK_ROOT=/usr/local/android-sdk
    - export PATH=$PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools

# git submodule
# Use sed to replace the SSH URL with the public URL, then initialize submodules
    - sed -i 's/git@github.com:/https:\/\/github.com\//' .gitmodules
    - git submodule update --init --recursive

# cocos setup 
    - cd ./cocos2d
    - python download-deps.py --remove-download=yes
    - python ./setup.py
    - export COCOS_CONSOLE_ROOT=`pwd`/tools/cocos2d-console/bin
    - export PATH=$PATH:$COCOS_CONSOLE_ROOT
    - export COCOS_TEMPLATES_ROOT=`pwd`/templates
    - export PATH=$PATH:$COCOS_TEMPLATES_ROOT
    - export ANT_ROOT=/usr/share/ant/bin
    - export PATH=$PATH:$ANT_ROOT
    - printenv

script:
    - cd ..
    - cocos compile -p android -j 8
```

躓き備忘録を以下に記しておく。

#### Travis CIは何で動いてるんだろ

Ubuntu 14.04（64bit）らしい。
なので各種Linuxのコマンドは使える。

#### cocosコマンド使えるようにする？

cocos2d-xの開発では、cocosコマンドによるビルドを使うのが便利である。
ただし、ちょっと環境構築が面倒な一面もある。

上記のymlでは、結果的にcocosコマンドを使える状態にしている。
「Travis CIはAndroidのビルドをサポートしている」ようなのだが、なのでもしかしたら、
cocosコマンドを使えるようにしなくても、Ant、ndk-buildあたりでなんとかできるのかもしれない。

と思ったのだが、どうやらNativeビルドには対応していないようである（あらかじめ用意されてはいない）。
なので、おとなしくcocosコマンドを使う方針で設定してみた。

#### NDKを解凍するときにTravis CIがerror 137で終わる

上記ymlでいうところの、以下の箇所を実行するとerror 137を報告してビルドが失敗に終わることがあった。

```yml .travi.yaml (part)
    - wget http://dl.google.com/android/ndk/android-ndk-r10d-linux-x86_64.bin
    - chmod a+x android-ndk-r10d-linux-x86_64.bin
    - ./android-ndk-r10d-linux-x86_64.bin -y | grep -v Extracting # because log will be too long!
```

解凍時にログをリダイレクトしているが、これをしないとログが大量に出過ぎることが原因でTravis CIに怒られ、ビルドが失敗に終わる。
それとは別に、解凍にメモリをくいすぎて、いわゆるメモリショートでプロセスが殺されるのがerror 137の原因らしい。。。

`sudo: required` をファイルの冒頭に書いていたのであるが、それを消したらerror 137は解消した。
意味不明だが、回避策もよくわからないのでもう追っかけるのはやめた。。。

#### Android SDKはあえて用意しなくていい

NDKは自前で用意する必要があるが、Android SDKはTravis CI側で用意してくれているので、あえて自前で用意しなくてもいい。

というか、Android SDKをダウンロード → Update SDK の流れを実施すると、今度はストレージ容量を圧迫してしまうため、
後続の処理（git submodule）実行時にストレージ容量不足でビルドが失敗に終わる。
有料にすれば解決するのかな？とりあえずわしの環境ではAndroid SDKを自前で準備することは出来なかった。。

#### gitスキームを用いているsubmodule取得に失敗する

SSH鍵の関係で、gitスキームを用いているsubmoduleの取得に失敗する。
なのでgitを用いてる部分はhttpsに無理やり書き換えている。以下の部分である。
涙ぐましい。

```yml .travis.yml (part)
# Use sed to replace the SSH URL with the public URL, then initialize submodules
    - sed -i 's/git@github.com:/https:\/\/github.com\//' .gitmodules
```

#### 環境変数設定を頑張る

cocos2d設定の過程で`setup.py`を実行するところがあるが、こいつは`.bashrc`を書き換える。
`.bashrc`内に`export`文がいくつか追加される。本来、`source ~/.bashrc`等とやれば環境変数が有効になるのであるが、、、
Travis CIのScript上では効かないので、しかたなく`.bashrc`に追記されるものと同等の設定を`.travis.yml`にて実施した。
以下の部分である。

```yml .travis.yml (part)
    - export COCOS_CONSOLE_ROOT=`pwd`/tools/cocos2d-console/bin
    - export PATH=$PATH:$COCOS_CONSOLE_ROOT
    - export COCOS_TEMPLATES_ROOT=`pwd`/templates
    - export PATH=$PATH:$COCOS_TEMPLATES_ROOT
    - export ANT_ROOT=/usr/share/ant/bin
    - export PATH=$PATH:$ANT_ROOT
```

ここまでいくと、Travis CI上で`cocos`コマンドが使えるようになる。
`cocos compile -p android -j 8`でビルド実行。APKが生成される（デバッグ版）はずである。

成果物がでてくるところまできたので、Travis CIの設定はひとまず以上とした。
おかげさまで、リポジトリにTravis CIバッヂを貼ることができた。

https://github.com/pankona/KonaReflection

#### DeployGateさんへのデプロイは

ビルド成功の後、curlコマンドでAPKをDeployGateさんへ送信すればいい模様。
できたらまた躓きポイントを載せていこうと思う。
追記：DeployGateさんへのアップロードについては[次回記事](http://pankona.github.io/blog/2015/04/22/travis-ci-with-deploygate/)も見てね。

今回はここまで。


