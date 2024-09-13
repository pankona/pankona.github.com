---
title: "DroidKaigi 2018 に向けて"
date: 2018-01-06T23:09:05+09:00
categories: [DroidKaigi]
---

## DroidKaigi 2018 に向けての準備

DroidKaigi 2018 にはしゃべる側で参加する予定である。
以下、準備しておこうと思う内容のメモ。

- ネタは gomobile でゲーム作った話。
  [golang-tokyo #9 にて発表済みの内容](http://pankona.github.io/slides/golang_tokyo_201709.html) をリファインする。
- DroidKaigi なので、主に Android 向けの開発について触れる。
- gomobile build のハマりどころは、概ねの内容はそのまま使う。
  - インテントを投げる、トーストを出す、アイコンのセット、あたりは新たに実際に動くコードを示すようにする。
  - 特に SharedPreference 使ったデータの保存を盛り込む。
    (これができるようになるだけでだいぶ開発しやすさが変わると思われる。)
- 引き合いに出す予定の [Kokeshi Scramble](http://pankona.github.io/slides/golang_tokyo_201709.html) は、できれば Google Play にあげとく。
  - できればもう少し遊べるようにしとく (ゲームバランス的な意味で) 。

DroidKaigi までに行う Kokeshi Scramble の改修は以下を想定。

- [gomo-simra](https://github.com/pankona/gomo-simra) の最新版に追従する。gomo-simra の API を変えてしまったので頑張って追従する。
- 召喚可能なユニット数に上限を設ける。
- もっと体力を多めにしてユニット一体一体を大事に扱うゲームデザインにする。
- もう少しプレイヤーに介入させるべく、ドラッグアンドドロップによるユニットの移動を導入する。
- そもそもちゃんと Android 端末上で動くようにしとく…。

その他、可能であれば行いたい細かい点の改善。

- ユニットの攻撃モーションを作る。剣であれば振る、魔法であれば詠唱から発動、など。
- 敵の残数を表示する。現状はいつまで続けていいか分からないので。

DroidKaigi までもう残り一ヶ月程度。
コツコツやっていくぞー。今年も頑張るぞー。
