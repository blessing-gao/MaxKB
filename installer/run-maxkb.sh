#!/bin/bash

# Clean up any old pid files
rm -f /opt/maxkb/app/tmp/*.pid

# Ensure PostgreSQL is ready (you can skip pg_isready if it's not needed)
# If needed, adjust the host and port to match the external PostgreSQL setup.
until pg_isready --host=${MAXKB_DB_HOST} --port=${MAXKB_DB_PORT}; do
  sleep 1
  echo "waiting for postgres"
done

# Start MaxKB application
python /opt/maxkb/app/main.py start
