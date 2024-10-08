---
title: "ゲームを作ろう"
date: 2021-02-20T23:16:14+09:00
draft: false
categories: ["ゲーム製作"]
---

時々作りたくなるよね、ということで案を練り始めた。

<!--more-->

## なんとなく構想

構想を練っている。なんとなくの概要は以下のようなもの。

- ローグライクみたいなノリ。Slay the Spire とか buriedbornes のような。
- プレイヤーはダンジョンのような何かに乗り込んでいく。ダンジョンでは戦闘が発生したり、何らかのイベントが起きたりする。定期的にボスが出たりもする。
- 深く深く探索することが目的。深度＝スコアでハイスコアを目指す。
- いつでも探索を終わらせることができる。終わらせた時点の深度がスコアになる。
- 体力が尽きる等して死ぬとスコアにならない。ご破算。
- 探索を中断することもできるが、減った体力が自然に回復したりはしない。サスペンド状態。サスペンドしておけば、その後また同じシチュエーションから再開できる。
- プレイヤーは、深度が同じくらいの位置にいる他のプレイヤーを攻撃することができる。倒すと自分の体力が回復する。負けたら死亡でご破算。相手は回復する。
- 中断中は、通りかかった他のプレイヤーを自動的に攻撃することもできる。
- 中断はいったんプレイを休憩する目的もありつつ、死にかけてももしかしたらだれかカモが通りかかって回復できるかもしれない、みたいな雰囲気で使うことを想定。
- プレイヤーを倒すと身ぐるみを剥ぐことができる。

## なにが面白いのか

- 繋がりのゆるい非同期なマルチプレイという形で、他人とのインタラクションを楽しむ（殺すか殺されるかしかないが）
  - 定型文を組み合わせて会話くらいできてもいいかもしれない
  - 他人をどうにかしないと深く進むことができない設計。もちつもたれつ（殺すか殺されるかしかないが）の人間関係を楽しむ
  - 他人と会えるかどうかは運になっちゃうし、奥深く行けば行くほど出会いの可能性は低くなるがまあいいのかも
  - 引き際を誤って虫の息で佇んでいると他人の養分になりがちなので、そういった焦りを楽しむ
- 誰が深くまで行った、というよりは、ここまで深く進んだ人が現れました、みたいな感じで、共闘のノリにしておくとジレンマが発生していいかもしれない（養分になればなるだけ人類の到達点は伸びるが、先に進むのは自分ではない、みたいな）
- 他人を倒して養分を吸いまくったとしても、最終的には探索を "終了" しないとスコアにならないので、他人の命を奪ったからには進まねばならぬということで終了しにくい気持ちにさせつつ、そうやって戦っていると次第に体力が減って今度は他人の養分になりがち、みたいなのが楽しいのでは（作者が）

## システム構成など

- ブラウザ上で動く類のゲームにしようかと思っており、フロントエンドと、あとは状態の保存や認証のためにいくらかバックエンドも必要な気がしている。
- フロントエンドはいったん何でもいいことにする（絵にこだわったりは作者のスキルの関係でできないし）。
- 認証は Firebase の何かを使うと楽ちんらしいので試してみる。
- バックエンドは... お金かけないためには GCP の Cloud Functions と DataStore みたいな組み合わせにしとけばとりあえずお金かかんなくて良さそうか、なんて気もしつつ、Cloud Functions に DDoS 食らって破産したりしないよね、みたいな心配がないこともない。まあお金で制限かけとけば大丈夫か...。

## MVP（とりあえずちっさく作る）

MVP といいつつ、"とりあえず動く" 段として目指す場所を定めておく。

- 認証できる。
- ダンジョンを進むことができる。
- 終了してスコアを記録できる（名前を記録できる）。あわよくばランキングみたいなものが見れる。
- 他のプレイヤー（仮想）がいて、殴ったり殴られたりできる。
  - 仮想と言っているのは、実際にプレイヤーデータを使うんではなくて、とりあえず作者が用意したカカシを使うということ

こんなところか。ゲームのメインとなる他人とのインタラクション（仮想）を試してみれば、楽しいか楽しくないか、楽しくないとして何が楽しくないか、みたいなこと考えたりできそうな。

## 作ろうな

こういうのは構成だけで終わること山の如しなので、作ってみような
