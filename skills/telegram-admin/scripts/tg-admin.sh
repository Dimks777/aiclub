#!/bin/bash
set -euo pipefail

# tg-admin.sh — вызов Telegram Bot API через токен агента из openclaw.json
# Использование: tg-admin.sh <account> <method> [key=value ...]

ACCOUNT="${1:?Использование: tg-admin.sh <account> <method> [key=value...]}"
METHOD="${2:?Использование: tg-admin.sh <account> <method> [key=value...]}"
shift 2

# Извлекаем токен бота из openclaw.json
TOKEN=$(node -e "
  const fs = require('fs');
  const p = process.env.HOME + '/.openclaw/openclaw.json';
  const c = JSON.parse(fs.readFileSync(p, 'utf8'));
  const t = c?.channels?.telegram?.accounts?.['${ACCOUNT}']?.botToken;
  if (!t) { console.error('Нет токена для аккаунта: ${ACCOUNT}'); process.exit(1); }
  process.stdout.write(t);
")

[ -z "$TOKEN" ] && echo "ОШИБКА: нет токена для '${ACCOUNT}'" >&2 && exit 1

URL="https://api.telegram.org/bot${TOKEN}/${METHOD}"
ARGS=()
for p in "$@"; do
  ARGS+=(-d "$p")
done

if [ ${#ARGS[@]} -eq 0 ]; then
  curl -s "$URL"
else
  curl -s "${ARGS[@]}" "$URL"
fi
