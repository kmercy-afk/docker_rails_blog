#!/usr/bin/env bash
# Exit on any error
set -e

echo "=== Installing dependencies ==="
bundle install

echo "=== Precompiling assets ==="
bundle exec rails assets:precompile

echo "=== Running database migrations ==="
bundle exec rails db:migrate

echo "=== Build completed successfully ==="