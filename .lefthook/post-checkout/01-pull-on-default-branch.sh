#!/bin/sh
# 最新のデフォルトブランチをローカルに自動で pull する Git フック

# 現在のブランチ名を取得する
branch=$(git rev-parse --abbrev-ref HEAD)

# `main` ブランチに `git checkout` した際に `git pull` を実行する
if [ "$branch" = "main" ]; then
  git fetch --prune origin
  git pull origin "$branch"
fi
