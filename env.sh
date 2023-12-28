#! /bin/bash
if [ -f .env ]; then
    # shellcheck disable=SC2046
    set -o allexport
    source .env set
    set +o allexport
  else
    echo "$0: No .env found. Copy example.env to .env and adjust as required." 1>&2
    exit 1
fi
