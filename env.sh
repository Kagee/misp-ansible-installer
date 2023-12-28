#! /bin/bash
if [ -f .env ]; then
    # shellcheck disable=SC2046
    export $(sed 's/#.*//g' .env | xargs | envsubst)
  else
    echo "$0: No .env found. Copy example.env to .env and adjust as required." 1>&2
    exit 1
fi
