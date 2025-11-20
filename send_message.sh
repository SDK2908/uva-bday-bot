#!/usr/bin/env bash
set -euo pipefail

if [ -z "${TELEGRAM_TOKEN:-}" ] || [ -z "${CHAT_ID:-}" ]; then
  echo "Please set TELEGRAM_TOKEN and CHAT_ID environment variables."
  exit 2
fi

if [ ! -f messages.txt ]; then
  echo "messages.txt not found!"
  exit 3
fi

IST_HOUR=$(TZ="Asia/Kolkata" date +%H)
LINE=$((10#$IST_HOUR + 1))
MSG=$(sed -n "${LINE}p" messages.txt)

PREFIX="🕘 ${IST_HOUR}:00 —"
TEXT="${PREFIX} ${MSG}"

curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
  --data-urlencode "chat_id=${CHAT_ID}" \
  --data-urlencode "text=${TEXT}" \
  --data-urlencode "parse_mode=Markdown" \
  -o /tmp/tg_send_result.json

cat /tmp/tg_send_result.json
