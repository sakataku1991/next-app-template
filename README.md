# next-app-template

Next.js アプリのテンプレートリポジトリです。


## 🧑‍💻 ローカル開発環境の構築手順

### 1. リポジトリの取得

自身の PC の 作業ディレクトリに `app-name` リポジトリを Clone する。

```shell
git clone https://github.com/sakataku1991/app-name.git
```

もしくは

```shell
git clone -c core.autocrlf=input git@github:sakataku1991/app-name.git
```

### 2. 環境変数の設定

`.env.example` をコピーして `.env` を作成する。

※ 作成された `.env` に記載されているコメントを参照しながら、必要な環境変数を設定してください。

### 3. Docker ネットワークの作成

開発環境用の Docker ネットワークを作成する。

```shell
docker network create app_name_network
```

### 4. ローカル環境でのホスト名の設定

ローカル開発環境のデフォルトのホスト名 `localhost` を `local.app-name.com` に変更する。

#### 4.1 `hosts` ファイルの設定

`/etc/hosts` ファイルにローカル開発環境用のドメインを追加する。

```shell
sudo vim /etc/hosts
```

※ `Password` の入力を求められた場合は、ご自身の PC 自体のログインパスワードを入力してください。

`/etc/hosts` ファイルに以下のコードを追加。

```hosts
127.0.0.1 local.app-name.com
```

### 5. 依存関係のインストール

Node.js パッケージのインストール前にプロジェクトルートの Node.js のバージョンを確認する。

```shell
node -v
```

> [!IMPORTANT]
> 本プロジェクトは Node.js のバージョン `v24.14.1` を前提としています。
> そのため次のステップの `npm ci` がうまくいかない場合は [Volta](https://github.com/volta-cli/volta) や [nodenv](https://github.com/nodenv/nodenv) などのバージョン管理ツールを使用し、プロジェクトルートの Node.js のバージョンを上記のバージョンに合わせてください。

以下のコマンドで Node.js パッケージをインストールする。

```shell
pnpm i --frozen-lockfile
```

### 6. Docker イメージの作成

開発環境用の Docker イメージをビルドする。

```shell
docker compose build
```

### 7. Docker コンテナの起動

ビルドした Docker イメージを元に Docker コンテナを起動する。

```shell
docker compose up --watch
```

### 8. Next.js アプリの動作確認

[http://local.app-name.com:3000/](http://local.app-name.com:3000/)

ブラウザで上記の URL にアクセスし、 Docker 開発環境上で Next.js アプリが動いていることを確認する。

### 9. Next.js アプリの停止

Next.js アプリを停止させるには、まず、 Docker の実行ログが表示されているターミナルで以下のいずれかのショートカットキーを実行する。

Windows の場合: `Ctrl + C`

Mac の場合: `⌃ control + C`

さらにターミナルで以下のコマンドを実行し、 Docker コンテナを削除する。

```shell
docker compose down
```


## 🔨 開発時に実行する必要のあるコマンド

### 1. 依存関係のアップデート

必要に応じて Node.js パッケージを更新する。

```shell
pnpm i --frozen-lockfile
```

### 2. 環境変数（ `.env` ）のアップデート

環境変数（ `.env` ）の更新があるかどうかも定期的に確認しましょう。

[.env.example](.env.example) の内容を確認し、環境変数の追加や変更があれば Docker コンテナの起動前にローカルの `.env` を更新してください。

### 3. Docker コンテナの起動

Docker イメージをビルドし、同時に Docker コンテナを起動する。

```shell
docker compose up --build --watch
```

### 4. 開発作業...

#### Next.js アプリ

[http://local.app-name.com:3000/](http://local.app-name.com:3000/)

ブラウザで上記の URL にアクセスし、開発作業を進める。

### 5. Next.js アプリの停止

Next.js アプリを停止させるには、まず、 Docker の実行ログが表示されているターミナルで以下のいずれかのショートカットキーを実行する。

Windows の場合: `Ctrl + C`

Mac の場合: `⌃ control + C`

さらにターミナルで以下のコマンドを実行し、 Docker コンテナを削除する。

```shell
docker compose down
```


## 🤜 設定している Git フック

> [!IMPORTANT]
> 本プロジェクトでは [Git フック](https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E3%82%AB%E3%82%B9%E3%82%BF%E3%83%9E%E3%82%A4%E3%82%BA-Git-%E3%83%95%E3%83%83%E3%82%AF) を活用し、開発時にリンターやテストツールが自動で実行される仕組みを構築しています。
>
> - Git フックの実行タイミング
>     - `git push` した時
> - 自動で実行される処理
>     - 「機密情報（シークレット）」のリンター（ Secretlint - `npm run lint:secret` ）
>     - JavaScript / TypeScript のリンター（ ESLint - `npm run lint` ）
>     - フォーマッター（ Stylistic - `npm run lint` ）
>     - 型チェック（ TypeScript - `npm run typecheck` ）
>     - 自動テスト（ Vitest - `npm run test` ）
>
> リンターや自動テストのエラーがすべて解消された状態でなければ、リモートリポジトリに `push` することができないという設定です。この Git フックの仕組みを有効化するため、各自のローカル開発環境にて以下に記載の初期設定を行ってください。
>
> なお、本プロジェクトにおいて Git フックの各種処理は [Lefthook](https://lefthook.dev/) というツールを使って管理しています。

### Git フック（ `Lefthook` ）の初期設定

Lefthook を PC にインストールする。

```shell
brew install lefthook
```

さらに本プロジェクトのルートディレクトリにいる状態で以下のコマンドを実行し、 Lefthook を初期化してください。

```shell
lefthook install
```

※ 上記2つのコマンドを実行後、以降は開発時に自動でリンターやテストツールが実行されるようになります。

### その他に設定している Git フック

`pre-push` で実行されるリンターや自動テスト以外にも、以下の Git フックを Lefthook で設定しています。

#### `post-checkout`

| スクリプト | 説明 |
| --- | --- |
| `01-pull-on-default-branch.sh` | 最新のデフォルトブランチをローカルに自動で pull する Git フック |
| `02-cleanup-stale-branches.sh` | リモートで既に merge 済み、もしくは、 close 済みの作業ブランチがローカルに残っていた場合、それを自動削除する Git フック |
| `03-auto-empty-commit.sh` | 新しい作業ブランチの作成時に空コミットを自動生成する Git フック |

#### `pre-commit`

| スクリプト | 説明 |
| --- | --- |
| `01-restrict-commit-to-default-branch.sh` | デフォルトブランチへの直コミットを禁止する Git フック |
| `02-update-allowed-github-actions.sh` | GitHub Actions 関連のコード変更があった場合に、使用を許可するアクションのホワイトリストを自動更新する Git フック |

#### `pre-push`

| スクリプト | 説明 |
| --- | --- |
| `01-restrict-push-to-default-branch.sh` | デフォルトブランチへの直プッシュを禁止する Git フック |

※ 上記スクリプトの実行後に、リンター・型チェック・自動テスト・ビルドチェックが実行されます。


## 📖️ 開発ルール

### GitHub Actions の管理

#### 各 GitHub Actions の説明

それぞれの GitHub Actions がどういった機能を果たしているかは、各 GitHub Actions の `.yml` ファイルのファイル冒頭に説明を記載しています。  
また、以下のドキュメントでも既存の GitHub Actions の概要を一覧することができます。

[docs/repository-structure.md](docs/repository-structure.md#.github/)

#### 使用を許可する GitHub Actions のリストの更新について

このリポジトリでは、GitHub Settings の「Allow or block specified actions and reusable workflows」で使用できるアクションを管理・制限しています（ホワイトリスト方式）。

許可するアクションの一覧は [.github/allowed-github-actions.md](.github/allowed-github-actions.md) に自動生成されます。

**使用する GitHub Actions を追加・変更したとき**は、以下の手順でホワイトリストを更新してください。

1. `.github/workflows/` または `.github/actions/` 以下のファイルを変更して `git commit` を実行する
2. Lefthook が自動で `.github/allowed-github-actions.md` を更新し、コミットに含める
    - ただし、この Lefthook（Git フック）は、以下の1つの条件を満たす場合にのみ実行されます
        1. 開発マシンに GitHub CLI をインストールしていること
            - `allowed-github-actions.md` を自動更新するスクリプトの中で gh コマンドを使用しています
            - 以下の公式ドキュメントを参考に、自身の開発マシンに GitHub CLI を導入しておきましょう
            - [GitHub CLI のドキュメント - GitHub ドキュメント](https://docs.github.com/ja/github-cli)
3. PR をマージしたあと、[.github/allowed-github-actions.md](.github/allowed-github-actions.md) の内容をリポジトリの Settings > Actions > Actions permissions の中の「Allow enterprise, and select non-enterprise, actions and reusable workflows」選択時の「Allow or block specified actions and reusable workflows」 に貼り付けて「Save」ボタンを押す
4. 既存の GitHub Actions や変更を加えた GitHub Actions の動作に問題がないことを確認する
