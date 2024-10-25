#!/bin/bash
set -e

mix local.hex --force
mix local.rebar --force

# install mix dependencies
mix deps.get && mix deps.compile

# Wait until Postgres is ready
while ! pg_isready # -h $PGHOST -p $PGPORT -U $PGUSER
do
  echo "$(date) - waiting for database to start"
  sleep 5
done

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $PGDATABASE does not exist. Creating..."
  createdb -E UTF8 $PGDATABASE -l en_US.UTF-8 -T template0
  mix ecto.create
  mix ecto.migrate
#   mix run priv/repo/seeds.exs
  echo "Database $PGDATABASE created."
fi

# Run the seeder
echo "Running seeder..."
mix run priv/repo/seeds.exs
seeder_exit_code=$?

if [ $seeder_exit_code -eq 0 ]; then
    echo "Seeder completed successfully!"
else
    echo "Seeder failed with exit code $seeder_exit_code"
fi

mix phx.server