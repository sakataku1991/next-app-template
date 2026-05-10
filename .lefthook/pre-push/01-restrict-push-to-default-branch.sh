#!/bin/sh
# デフォルトブランチへの直プッシュを禁止する Git フック

# 現在のブランチ名を取得する
branch=$(git rev-parse --abbrev-ref HEAD)

# `main` ブランチへの直接の `git push` を禁止する
if [ "$branch" = "main" ]; then
  echo "Error: You cannot push directly to the '$branch' branch."
  echo "Please push your changes to a feature branch or create a pull request."
  exit 1
fi
