#!/bin/sh

set -e

COMPOSE="docker compose --env-file=.env -f docker/compose.yaml"

case "$1" in
  up)
    $COMPOSE up -d --remove-orphans
    ;;
  down)
    $COMPOSE down
    ;;
  cleanup)
    $COMPOSE down -v --remove-orphans
    ;;
  *)
    echo "Usage: $0 {up|down|cleanup}"
    exit 1
    ;;
esac
