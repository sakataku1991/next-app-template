# syntax=docker/dockerfile:1

FROM node:24.14.1-alpine AS base

WORKDIR /app

RUN corepack enable

# Stage 1. 依存関係のインストール用のステージ（共通）
FROM base AS dependencies

COPY package.json pnpm-lock.yaml* .npmrc* ./
RUN pnpm i --frozen-lockfile

# Stage 2. Next.jsのローカル開発環境用のステージ
FROM base AS local

# 依存関係をdependenciesステージからコピー
COPY --from=dependencies /app/node_modules ./node_modules
COPY package.json pnpm-lock.yaml* .npmrc* ./

# Next.jsの実行に必要なファイルをDockerコンテナ内にコピー
COPY src ./src
COPY public ./public
COPY next.config.ts .
COPY postcss.config.mjs .
COPY tsconfig.json .

# Next.jsの開発サーバーを起動
CMD ["npm", "run", "dev:docker"]

# Stage 3. Next.jsのビルド用のステージ
FROM base AS builder

# 依存関係をdependenciesステージからコピー
COPY --from=dependencies /app/node_modules ./node_modules
COPY package.json pnpm-lock.yaml* .npmrc* ./

# Next.jsのビルドに必要なファイルをDockerコンテナ内にコピー
COPY src ./src
COPY public ./public
COPY next.config.ts .
COPY postcss.config.mjs .
COPY tsconfig.json .

# Next.jsをビルド
RUN npm run build

# Stage 4. Next.jsの実行用のステージ
FROM base AS production

# 本番環境用の環境変数
ENV NODE_ENV=production

# readonlyのためボリュームをマウントして書き込めるようにする
VOLUME ["/app/.next/cache"]

# 必要最小限の権限を持つユーザーで実行するための設定
# https://www.docker.com/ja-jp/blog/understanding-the-docker-user-instruction/
RUN addgroup --system --gid 1001 nodejs && \
  adduser --system --uid 1001 nextjs
USER nextjs

# 本番環境の実行に必要なファイルをDockerコンテナ内にコピー
COPY --from=builder /app/public ./public

# Next.jsのビルドイメージを削減するための設定
# Next.jsのstandaloneモードで出力されたファイルをコピー
# https://nextjs.org/docs/advanced-features/output-file-tracing
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

EXPOSE 3000

# Next.jsを実行
CMD ["node", "server.js"]
