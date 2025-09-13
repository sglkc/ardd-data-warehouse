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

sqlmesh -p sqlmesh_project/ --dotenv .env plan $1
