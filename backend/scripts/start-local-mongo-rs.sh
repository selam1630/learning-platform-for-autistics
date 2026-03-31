#!/usr/bin/env bash

set -euo pipefail

DB_PATH="/tmp/ethiopia-autism-rs"
LOG_PATH="$DB_PATH/mongod.log"
PID_PATH="$DB_PATH/mongod.pid"
PORT="27018"

mkdir -p "$DB_PATH"

if mongosh --port "$PORT" --quiet --eval 'db.adminCommand({ ping: 1 })' >/dev/null 2>&1; then
  echo "Replica-set MongoDB is already running on port $PORT."
  exit 0
fi

mongod \
  --dbpath "$DB_PATH" \
  --replSet rs0 \
  --bind_ip 127.0.0.1 \
  --port "$PORT" \
  --fork \
  --logpath "$LOG_PATH" \
  --pidfilepath "$PID_PATH"

sleep 2

if ! mongosh --port "$PORT" --quiet --eval 'db.adminCommand({ ping: 1 })' >/dev/null 2>&1; then
  echo "MongoDB started but is not responding on port $PORT."
  exit 1
fi

if ! mongosh --port "$PORT" --quiet --eval 'rs.status().ok' >/dev/null 2>&1; then
  mongosh --port "$PORT" --quiet --eval "rs.initiate({_id: 'rs0', members: [{ _id: 0, host: '127.0.0.1:$PORT' }]})"
fi

echo "Replica-set MongoDB is ready on port $PORT."
