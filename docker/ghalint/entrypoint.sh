#!/bin/sh
set -eu

ghalint run

# 引数が渡された場合は、リポジトリ内のすべての action.yml に対して run-action を実行する
if [ $# -gt 0 ]; then
  find . -name "action.yml" -type f -print0 | xargs -0 -n1 ghalint run-action
fi
