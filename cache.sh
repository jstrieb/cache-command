#!/bin/bash

set -e

TMP_DIR="/tmp/cache-command"

if [ "$#" = 0 ] || [ "${1}" = "-h" ] || [ "${1}" = "--help" ]; then
  echo "Usage: ${0} <command>"
  exit
fi

mkdir --parents "${TMP_DIR}"
ARG_HASH="$(echo "$@" \
  | sha256sum \
  | grep --only-matching --extended-regexp '\w+')"
FILE_PATH="${TMP_DIR}/${ARG_HASH}"
if [ ! -f "${FILE_PATH}" ]; then
  echo "Running: $*" 2>&1
  eval "$@" > "${FILE_PATH}"
else
  echo "Loading command from cache: $*" 2>&1
fi
cat "${FILE_PATH}"
