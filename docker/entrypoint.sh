#!/bin/sh
set -e

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_USER="${DB_USER:-postgres}"
DB_PASSWORD="${DB_PASSWORD:-postgres}"

BIND_IP="${BIND_IP:-0.0.0.0}"
REST_IP="${REST_IP:-0.0.0.0}"
PUBLIC_IP="${PUBLIC_IP:-127.0.0.1}"

for cfg in database.Account.config database.Worlds.config; do
    envsubst < "/app/${cfg}.template" > "/app/${cfg}"
done

envsubst < /app/config.ini.template > /app/config.ini

exec ./Blizzless
