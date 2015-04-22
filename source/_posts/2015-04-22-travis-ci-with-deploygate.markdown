---
layout: post
title: "Cocos2d-x + Travis CI + DeployGate"
date: 2015-04-22 19:25:11 +0900
comments: true
categories: "cocos2d-x"
---

[前回](http://pankona.github.io/blog/2015/04/19/cocos-with-travisci/)の記事にて、cocos2d-xでのアプリ作成とTravis CIを連携させるとこまでいった。
今回は成果物であるAPKをDeployGateにアップロードするところについて書き留めておく。

## だいたいのやり方

* ビルドが成功したら`curl`コマンドにてDeployGateにAPKをアップロードする。
* アップロードにあたってDeployGateのAPI Keyが必要になる。DeployGateにログインして個人設定的なところを見れば載っている。
* API Keyは.travis.ymlに書くことになるが、そのまま載せちゃうとセキュリティ的に問題なので暗号化する。
    * 暗号化には`travis`コマンドを用いる。

## ちょっと細かいやり方

まずはAPKアップロード成功後の.travis.ymlを載せておく。

```yml .travis.yml
language: android

# Handle git submodules yourself
git:
    submodules: false

env:
  global:
    secure: "TeSR8JLJd2Z0erCxcgLinC+me5SfwpgcCNwiTsqXn09erOgos2+mUbVQaSyo7Bw4OF4TmNpejX+jETd/lL4fTiWRDw6NW/cqEelk57fXJ5mmf5ey+tB1EkMFwd8x7Fw2vBe4xtO8KeohI6D1Gtu1qTYU9t9x4bhAd4qL15Y5osE="

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
    - cd ..

script:
    - cocos compile -p android -j 8

after_success:
    - echo $TRAVIS_BRANCH
    - echo $TRAVIS_PULL_REQUEST
    - '[ "$TRAVIS_BRANCH" == "master" -a "$TRAVIS_PULL_REQUEST" == "false" ] && curl -F "file=@./bin/debug/android/KonaReflection-debug.apk" -F "token=${DEPLOYGATE_TOKEN}" -F "message=Deploy from Travis CI" https://deploygate.com/api/users/pankona/apps'
```

### 前回からの変更点（APKアップロードのために追加した部分）

前回から増えたり変更したりしたのは以下。

```yml .travis.yml (part)
env:
  global:
    secure: "TeSR8JLJd2Z0erCxcgLinC+me5SfwpgcCNwiTsqXn09erOgos2+mUbVQaSyo7Bw4OF4TmNpejX+jETd/lL4fTiWRDw6NW/cqEelk57fXJ5mmf5ey+tB1EkMFwd8x7Fw2vBe4xtO8KeohI6D1Gtu1qTYU9t9x4bhAd4qL15Y5osE="
```

```yml .travis.yml (part)
    - '[ "$TRAVIS_BRANCH" == "master" -a "$TRAVIS_PULL_REQUEST" == "false" ] && curl -F "file=@./bin/debug/android/KonaReflection-debug.apk" -F "token=${DEPLOYGATE_TOKEN}" -F "message=Deploy from Travis CI" https://deploygate.com/api/users/pankona/apps'
```

後者の部分で、`${DEPLOYGATE_TOKEN}`という環境変数を参照しているが、これを設定しているのが前者の部分。

### DEPLOYGATE_TOKENの暗号化

以下のコマンドでDeployGateのAPI Keyを暗号化する。

`$ gem install travis ` # travisコマンドを使えるようにする。
`$ travis encrypt DEPLOYGATE_TOKEN={My DeployGate API Key}` # DeployGateで確認したAPI Keyを暗号化するコマンド（中括弧はいらない）。

このコマンドで得られた文字列をそのまま.travis.ymlに貼っつければOKである。

### いつアップロードするか

以下の条件を満たした場合のみ、APKのアップロードを行うようにした。
これは、Pull Requestがmasterにマージされたとき、を意味している（つもり）。
`"$TRAVIS_BRANCH" == "master" -a "$TRAVIS_PULL_REQUEST" == "false" ]`

これをやっとかないと、ブランチにコミットをPUSHしたタイミングだったりPull Requestを作ったタイミングだったり、でアップロードが走る。
個人的にはやり過ぎ感があったので、APKはmasterからだけ作ればいいやという制限を施した。

### これがそこそこ楽だと思います

AndroidアプリにAPKをいちいち頑張って転送しなくても、開発中アプリをインストールすることができるようになった。
ちなみに、アップロードされたAPKはDeployGateアプリ経由で取得することになる。

今回はここまで。


