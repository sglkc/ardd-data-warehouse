#!/bin/sh

set -e

if [ ! -x "$(command -v uv)" ]; then
  echo "uv not installed, please read README.md"
  exit 1
fi

if [ ! -f .venv/bin/activate ]; then
  echo "No virtualenv found, creating with uv..."
  uv venv
fi

if [ -z "$VIRTUAL_ENV" ]; then
  echo "Activating .venv..."
  . .venv/bin/activate
fi

uv run --env-file=../.env --directory=./dlt_project load_excel_source.py $1
