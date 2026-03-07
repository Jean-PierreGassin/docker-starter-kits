#!/usr/bin/env bash
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_DIR="$(mktemp -d)"
APP_DIR="$TMP_DIR/app"
ENV_FILE="$TMP_DIR/.env"

cleanup() {
  docker compose --project-name "$APP_NAME" --env-file "$ENV_FILE" down -v --remove-orphans >/dev/null 2>&1 || true
  rm -rf "$TMP_DIR"
}

trap cleanup EXIT

mkdir -p "$APP_DIR/public"

cat >"$APP_DIR/public/index.php" <<'PHP'
<?php
header('Content-Type: text/plain');
echo 'smoke-test-ok';
PHP

APP_NAME="smoke$(date +%s)"
BASE_PORT="$((20000 + RANDOM % 10000))"

cp "$KIT_DIR/.env.example" "$ENV_FILE"

{
  echo
  echo "APP_NAME=$APP_NAME"
  echo "APP_HOST_PATH=$APP_DIR"
  echo "APP_HTTP_PORT=$BASE_PORT"
  echo "MAILHOG_SMTP_PORT=$((BASE_PORT + 1))"
  echo "MAILHOG_HTTP_PORT=$((BASE_PORT + 2))"
  echo "MYSQL_PORT=$((BASE_PORT + 3))"
  echo "REDIS_PORT=$((BASE_PORT + 4))"
} >>"$ENV_FILE"

cd "$KIT_DIR"

compose() {
  docker compose --project-name "$APP_NAME" --env-file "$ENV_FILE" "$@"
}

compose up -d --build

MYSQL_READY=false
for _ in $(seq 1 30); do
  if compose exec -T mysql mysqladmin ping -h127.0.0.1 -uroot -proot >/dev/null 2>&1; then
    MYSQL_READY=true
    break
  fi
  sleep 2
done

if [[ "$MYSQL_READY" != "true" ]]; then
  compose logs --no-color mysql >&2 || true
  echo "MySQL did not become ready during smoke test." >&2
  exit 1
fi

compose ps -a
compose exec -T node sh -lc 'node -v && yarn -v'
compose exec -T php sh -lc 'php -v && composer --version'
compose exec -T mysql mysqladmin ping -h127.0.0.1 -uroot -proot
compose exec -T redis redis-cli ping

NGINX_OUTPUT="$(compose exec -T nginx sh -lc 'wget -qO- http://127.0.0.1/')"
if [[ "$NGINX_OUTPUT" != "smoke-test-ok" ]]; then
  echo "Unexpected Nginx response: $NGINX_OUTPUT" >&2
  exit 1
fi
