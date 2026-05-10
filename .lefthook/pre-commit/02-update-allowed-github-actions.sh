#!/bin/sh
set -eu

# .github/workflows/ と .github/actions/ 以下の yml ファイルから
# 外部アクションのリストを抽出し、.github/allowed-github-actions.md に書き出す
#
# 出力フォーマット:
#   - owner/repo のみ（2セグメント） → owner/repo@*
#   - owner/repo/path... （3セグメント以上） → owner/repo/*

OUTPUT_FILE=".github/allowed-github-actions.md"

# uses: の行から外部アクション名だけを取り出す（stdin から読み込む）
parse_uses() {
  grep "uses:" 2>/dev/null \
    | sed 's/.*uses:[[:space:]]*//' \
    | sed 's/[[:space:]]*#.*//' \
    | sed 's/^[[:space:]]*//' \
    | grep -v '^\.' \
    | grep -v '^$' \
    || true
}

# ローカルの .github/ 以下から uses: を抽出する
extract_local_uses() {
  grep -rh "uses:" .github/workflows/ .github/actions/ 2>/dev/null \
    | parse_uses \
    || true
}

# owner/repo@sha → owner/repo@* または owner/repo/* に変換してソート・重複排除する
format_actions() {
  sed 's/@.*//' \
    | sort -u \
    | awk -F'/' '{
        if (NF >= 3) print $1"/"$2"/*"
        else if (NF == 2) print $0"@*"
      }' \
    | sort -u
}

{
  echo "<!-- このファイルは自動生成されます。手動で編集しないでください。 -->"
  echo "<!-- 生成スクリプト: .lefthook/pre-commit/02-update-allowed-github-actions.sh -->"
  echo ""
  echo "# 使用を許可する GitHub Actions のリスト"
  echo ""
  echo "本リポジトリの Settings > Actions > Actions permissions の中の「Allow enterprise, and select non-enterprise, actions and reusable workflows」選択時の「Allow or block specified actions and reusable workflows」に設定する GitHub Actions の一覧です。"
  echo ""
  echo "本リポジトリでは、第三者によって悪意のある GitHub Actions が実行されることを防ぐため、使用可能な GitHub Actions をホワイトリスト方式で管理しています。"
  echo ""
  echo "使用する GitHub Actions に追加や変更があった際には、以下のリストをそのまま「Allow or block specified actions and reusable workflows」のテキストエリアにコピペし、保存（「Save」ボタンをポチッとな）してホワイトリストを更新してください。"
  echo ""
  echo "\`\`\`text"
  extract_local_uses | format_actions | awk '{
    lines[NR] = $0
  }
  END {
    for (i = 1; i <= NR; i++) {
      if (i < NR) print lines[i]","
      else print lines[i]
    }
  }'
  echo "\`\`\`"
} > "$OUTPUT_FILE"

echo "✅ $OUTPUT_FILE を更新しました"
