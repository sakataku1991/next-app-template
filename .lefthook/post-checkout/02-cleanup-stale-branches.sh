#!/bin/sh
# リモートで既に merge 済み、もしくは、 close 済みの作業ブランチがローカルに残っていた場合、それを自動削除する Git フック

# リモート側で merge 済みの PR 、かつ、削除済みのリモートブランチに対応するローカルブランチを削除する
# ※ Squash Merge に対応するため、`git branch --merged` ではなくリモート追跡ブランチの状態で判定する
git branch -vv | grep ': gone]' | awk '{print $1}' | while read -r branch; do
  echo "Deleting local branch: $branch"
  git branch -D "$branch"
done

# リモート側で close 済みの PR に対応するローカルブランチを削除する
# ※ カレントブランチは `git branch` の出力で `*` が付くため除外される
git branch | grep -v '\*' | awk '{print $1}' | while read -r branch; do
  pr_state=$(gh pr view "$branch" --json state --jq '.state' 2>/dev/null)
  if [ "$pr_state" = "CLOSED" ]; then
    echo "Deleting local branch (PR closed): $branch"
    git branch -D "$branch"
  fi
done
