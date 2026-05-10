# リポジトリ構造定義書 (Repository Structure Document)

### .github/

```text
.github/
├── actions/
│   ├── actionlint/action.yml         # actionlint 実行アクション
│   ├── ghalint/action.yml            # ghalint 実行アクション
│   └── zizmor/action.yml             # zizmor 実行アクション
├── ISSUE_TEMPLATE/
│   └── PBIのテンプレート.md           # プロダクトバックログアイテムの Issue テンプレート
├── scripts/
│   └── empty-commit.sh               # 空コミット作成スクリプト
├── workflows/
│   ├── auto-assign-pr-assignees.yml  # PR 作成者を Assignees に自動アサイン
│   ├── auto-empty-commit.yml         # 作業ブランチ作成時の自動空コミット生成
│   ├── ci-github-actions.yml         # GitHub Actions CI（actionlint / ghalint / zizmor）
│   └── scan-secrets.yml              # 秘匿情報の混入箇所（ハードコーディング）の検出
├── allowed-github-actions.md          # リポジトリで使用を許可する GitHub Actions の一覧（自動生成）
├── dependabot.yml                     # Dependabot の設定
└── pull_request_template.md           # PR テンプレート
```
