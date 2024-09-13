---
title: "WSL2 を絶対に停止したいときに唱えるコマンド"
date: 2023-06-12T14:03:54+09:00
draft: false
categories: ["Linux"]
---

WSL2 が定期的に CPU 100% でメモリガバ食いみたいになってしまう問題があり、以前改善策に関するブログを書いた。
Refs: [WSL2 が時々 CPU 100％ 使っちゃうときは guiApplication=false の設定を入れると改善するかもしれない](https://pankona.github.io/blog/2022/12/16/wsl2-uses-cpu-100-percent/)

しかしそれでもやっぱり WSL2 が暴走状態になってしまうことがあって、しょうがないからタスクキルしたいんだけどタスクマネージャーからの強制終了は受け付けてくれないし、コマンドプロンプトからの `wsl2 --shutdown` も応答が返ってこなくて効かないし、もはや PC を再起動するくらいしか打つ手がないかに見えていた。えれー不便。

しかし実は "絶対 WSL2 打ち倒すコマンド" があった。PowerShell を管理者権限で実行し、 `taskkill /f /im wslservice.exe` って打てばいいようだ。実際にこのコマンドで "突き刺さった状態の WSL2" が終了してくれた。
Refs: [All WSL commands hang (including wsl --shutdown) but WSL is constantly using 30-40% CPU #8529](https://github.com/microsoft/WSL/issues/8529#issuecomment-1263463528)

![image](https://github.com/pankona/pankona.github.com/assets/6533008/6a93a157-76ad-4304-98a5-050090cb95b7)
PowerShell を使って WSL2 ぶっちめたところ

いったんこれを事あるごとに実行することでそこまで不便を強いられる感じではなくなってきた。が、先述の issue も Open のままだし、早いところ根本対処が入って欲しいところではある。

## 参考 URL

- [WSL2 causing high CPU load #7893](https://github.com/microsoft/WSL/issues/7893)
- [All WSL commands hang (including wsl --shutdown) but WSL is constantly using 30-40% CPU #8529](https://github.com/microsoft/WSL/issues/8529)
