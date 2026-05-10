#!/bin/sh
# デフォルトブランチへの直コミットを禁止する Git フック

# 現在のブランチ名を取得する
branch=$(git rev-parse --abbrev-ref HEAD)

# `main` ブランチへの直接の `git commit` を禁止する
if [ "$branch" = "main" ]; then
  echo "Error: You cannot commit directly to the '$branch' branch."
  echo "Please create a feature branch and commit your changes there."
  exit 1
fi
