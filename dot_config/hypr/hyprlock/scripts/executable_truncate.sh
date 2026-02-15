#!/usr/bin/env bash

input="$1"
length="$2"
truncate_string=${3:-"..."}

if [ -z "$input" ]; then
  echo "Error: string required. (Format: ./truncate.sh STRING [LENGTH] [STRING])." >&2
  exit 1
fi

if [ -z "$length" ]; then
  echo "$input"
  exit 0
fi

if [ "${#input}" -gt "$length" ]; then
  echo "$(grep -oE "^.{0,$length}" <<<"$input")$truncate_string"
else
  echo "$input"
fi
