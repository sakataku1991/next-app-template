#!/bin/sh
# 新しい作業ブランチの作成時に空コミットを自動生成する Git フック
# 一つの PR の実装に要した時間を正確に計測するため、ブランチの作成と同時に空コミットを生成する

# post-checkoutフックから渡される引数
# チェックアウト前のHEADコミットハッシュ
PREV_HEAD=$1
# チェックアウト後のHEADコミットハッシュ
CURR_HEAD=$2
# 操作種別フラグ（1=ブランチ、0=ファイル）
CHECKOUT_TYPE=$3

# git checkout完了直後はindex.lockのファイルロックがまだ解除されていない事がある為、少しだけ待機する。
sleep 0.1

# チェックアウト前後のハッシュを比較し、異なる場合は新規ブランチ作成ではなく既存ブランチへの移動とする。
# 例:git checkout feature/existingA → git checkout feature/existingB
if [ "$PREV_HEAD" != "$CURR_HEAD" ]; then
  exit 0
fi

# ファイルのチェックアウトでは実行しない
# 例:git checkout -- file.txt
if [ "$CHECKOUT_TYPE" != "1" ]; then
  exit 0
fi

# 現在のブランチ名と、移動前のブランチ名を取得
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
FROM_BRANCH_NAME=$(git rev-parse --abbrev-ref @{-1} 2>/dev/null)

# ブランチ名を比較し、同一ブランチの再チェックアウト時は実行しない
# 例:git checkout feature/AAA　→ git checkout feature/AAA
if [ -n "$FROM_BRANCH_NAME" ] && [ "$FROM_BRANCH_NAME" = "$CURRENT_BRANCH" ]; then
  exit 0
fi

# originに同じブランチがある場合は実行しない（ローカルのリモート追跡情報を参照）
# 例:git checkout feature/nodiffmain → git checkout main
if git show-ref --verify --quiet refs/remotes/origin/"$CURRENT_BRANCH"; then
  exit 0
fi

echo "新規ブランチの作成を検知しました: $CURRENT_BRANCH"

# ステージングに変更がある場合はメッセージを出して終了
if ! git diff --cached --quiet; then
  echo "ステージングに変更があるため、空コミットの作成はスキップしました"
  echo "手動で空コミットの作成を行なってください"
  exit 0
fi

# 空コミット作成（共通スクリプトを呼び出し）
.github/scripts/empty-commit.sh
