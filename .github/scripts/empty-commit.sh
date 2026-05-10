#!/bin/bash
# .github/scripts/empty-commit.sh
#
# 空コミットを作成する共通スクリプト
# Lefthook と GitHub Actions から呼び出される

BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
COMMIT_MESSAGE="auto empty commit on branch=$BRANCH_NAME"

# 同じコミットメッセージが既に存在するかチェック
if git log --grep="$COMMIT_MESSAGE" --oneline -1 | grep -q .; then
  echo "空コミットが既に存在するため、作成をスキップしました"
  exit 0
fi

echo "空コミットを作成します..."
git commit --allow-empty -m "$COMMIT_MESSAGE" --no-verify
