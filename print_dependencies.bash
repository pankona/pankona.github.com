#!/usr/bin/env bash

set -euxo pipefail

nix --version
hugo version
sass --version
go version
make --version
dprint --version
typos --version
convert --version
actionlint --version
ls --version
nixfmt --version
nixd --version
peco --version
vim --version | sed -n '1p'
markdownlint-cli2 --version | grep 'markdownlint v'
