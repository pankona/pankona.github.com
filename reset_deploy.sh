#!/bin/bash -e

rm -rf ./_deploy
mkdir _deploy
cd _deploy
git init
git remote add -t master -f origin https://github.com/pankona/pankona.github.com

