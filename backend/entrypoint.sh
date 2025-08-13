#!/bin/bash
set -e

echo "Waiting for MySQL to be ready..."
until mysqladmin ping -h"$DB_HOST" -P"$DB_PORT" --silent; do
    sleep 2
done

echo "MySQL is ready, creating tables..."
node src/utils/databaseCreator.js

echo "Starting the backend server..."
node server.js &

echo "Waiting for backend server to be ready on port 3000..."
timeout=30
while ! nc -z localhost 3000; do
  timeout=$((timeout - 1))
  if [ $timeout -le 0 ]; then
    echo "Timeout waiting for backend server"
    exit 1
  fi
  sleep 1
done

if [ "$POPULATE_DB" = "true" ]; then
  echo "Backend server is ready, populating the database..."
  node src/utils/populateDB.js
else
  echo "POPULATE_DB not true, skipping database population."
fi

wait
