#!/bin/sh
set -e

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_USER="${DB_USER:-postgres}"
DB_PASSWORD="${DB_PASSWORD:-postgres}"

BIND_IP="${BIND_IP:-0.0.0.0}"
REST_IP="${REST_IP:-0.0.0.0}"
PUBLIC_IP="${PUBLIC_IP:-127.0.0.1}"

LOG_MODE="${LOG_MODE:-Console}"
LOG_LEVEL_MIN="${LOG_LEVEL_MIN:-Info}"
LOG_LEVEL_MAX="${LOG_LEVEL_MAX:-PacketDump}"

case "$LOG_MODE" in
  Ansi)    ANSI_ENABLED=true;  CONSOLE_ENABLED=false ;;
  Console) ANSI_ENABLED=false; CONSOLE_ENABLED=true  ;;
  *)
    echo "ERROR: LOG_MODE must be 'Ansi' or 'Console', got: '${LOG_MODE}'. Check .env file." >&2
    exit 1
    ;;
esac

export ANSI_ENABLED CONSOLE_ENABLED LOG_LEVEL_MIN LOG_LEVEL_MAX

for cfg in database.Account.config database.Worlds.config; do
    envsubst < "/app/${cfg}.template" > "/app/${cfg}"
done

envsubst < /app/config.ini.template > /app/config.ini

exec ./Blizzless
