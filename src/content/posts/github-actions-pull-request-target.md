---
title: "fork されたリポジトリからの pull request で発火した GitHub Actions で fork 元の secrets を参照する"
date: 2021-03-29T12:24:46+09:00
draft: false
categories: ["GitHub Actions"]
---
           
タイトルが長い。

fork されたリポジトリからの pull request を受け取ったとき、GitHub Actions が fork 元のリポジトリの secrets にアクセスするためには例えば `pull_request_target` という trigger を使うやり方がある。`pull_request_target` という trigger は便利なんだけど、これを無配慮に使うとセキュリティ的に危ういということが GitHub のドキュメントにはつらつら書かれており、まあつまりどういうことなんや、どう使えばええということなんや、ということで色々調べたのでメモしておく。

<!--more-->

## まず先に `pull_request` という trigger

github actions の trigger にはいろいろなものを設定できるが、基本的には `pull_request` という trigger を使えば pull request 契機の何かをさせる (CI とか) には十分であろうと思う。

なんだけど、この `pull_request` という trigger は fork からの pull request を受け取ったときには「fork 先のリポジトリの設定で github actions が動く」というような振る舞いをする。これで何が困るかというと、例えば fork 元で設定している secrets にアクセスできないという点。secrets にアクセスできないということは、たとえば普通 secrets に入れておいて github actions で用いたくなるような `GITHUB_TOKEN` だとか `SLACK_TOKEN` だとか、あるいは `FIREBASE_SERVICE_ACCOUNT_XXX` のようなものだとかが参照できないということが起こる。このへんの TOKEN を使って CI を契機に pull request にコメントしたり Slack にお知らせ飛ばしたり、firebase hosting に preview のためにアップロードしたりとか、そういうのやりたいとしてもできないということになる。

## `pull_request_target` という trigger を使うと便利、だが

trigger を `pull_request` の代わりに `pull_request_trigger` を使うようにすると、「fork 先からのリポジトリからの pull request でも fork 元の設定で github actions が動く」というのを達成できる。これならば secrets にアクセスできる。やったね。

と思うんだけど、これを無配慮に使ってしまうとセキュリティ的に良くないことになる。たとえば pull request の author が悪いやつで、CI の最中に secrets をダンプ (あるいはどこかに送信) するようなコードを pull request で送りつけられてしまうと、一発で secrets が漏れることになってしまう。これはまずい。

## 使いたかったら何に気をつけるべきか

じゃあどうやって使えばいいんですか、ってことで調べていくと [github actions のセキュリティに関する GitHub のブログ](https://securitylab.github.com/research/github-actions-preventing-pwn-requests/) が出てくる。これによると、`pull_request_target` を使う場合は、たとえば「特定のラベルが貼られたもの」に限定して github actions を実行するような制御を行うのが良いとして例示されている。pull request にラベルを貼れるのはそれ相応の権限をもった人に限られるので (fork を作った人は colaborator でもない限り fork 元の issue や pull request にラベルを貼ることはできない)、fork 元の人がちゃんとパッチの中身を確認し、問題がないことを確認してからラベルを貼るってやれば大丈夫だよね、という意図かと思う。

たとえば、`ok to test`というラベルが貼られたら CI を発火させる、みたいなのはこんなふうに書けるかと思う。
worflow の冒頭を抜粋。

```yaml
name: Deploy to Firebase Hosting on PR
'on':
  pull_request_target:
    types: [labeled]
jobs:
  build_and_preview:
    runs-on: ubuntu-latest
    if: contains(github.event.pull_request.labels.*.name, 'ok to test')
```

こうやると、この workflow はラベルが貼られたとき、かつラベルの中身が `ok to test` であれば実行される、という意味にできる。

このとき、`pull_request_target` の types に `labeled` 以外のものを指定してしまうと (例えば push とか reopen とか)、一度 `ok to test` ラベルを貼ったあとにヤバいコードを push されてしまう、みたいなシチュエーションのときにも github actions が実行されてしまってやはり secrets が漏れる、みたいなこともありえそう。なので「`ok to test` というラベルが貼られたときしか発火しない workflow」(もう一回 CI したかったらラベルを貼り直す) という設計で workflow を作るのが盤石なやり口なのかなーと思う。ややめんどうかもしれないがやむなし。

## 参考文献

- [ワークフローをトリガーするイベン - GitHub Docs](https://docs.github.com/ja/actions/reference/events-that-trigger-workflows)
- [Keeping your GitHub Actions and workflows secure: Preventing pwn requests](https://securitylab.github.com/research/github-actions-preventing-pwn-requests/)
- [実際に自分がこさえた pull_request_target trigger を使っている github actions ワークフロー](https://github.com/pankona/moguri/blob/ed52f4731e87c4b8902fd478dc9619031e5a0da6/.github/workflows/firebase-hosting-pull-request.yml)

