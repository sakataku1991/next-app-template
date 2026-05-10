#!/bin/sh
set -eu

# ZIZMOR_GITHUB_TOKEN が空文字列の場合は unset する
# （Docker の env で空文字列が渡されると zizmor がエラーになるため）
if [ -n "${ZIZMOR_GITHUB_TOKEN:-}" ]; then
  export GH_TOKEN="${ZIZMOR_GITHUB_TOKEN}"
else
  unset ZIZMOR_GITHUB_TOKEN 2>/dev/null || true
fi

zizmor . \
  --color=always \
  --persona="${ZIZMOR_PERSONA:-regular}"
