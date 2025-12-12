#!/usr/bin/env bash

input="$1"
truncate_string=${3:-"..."}
input_length=$(wc -c <<<"$input")
truncate_string_length=$(wc -c <<<"$truncate_string")
length="$2"

output="$input"

if [ -z "$input" ]; then
  echo "Error: string required. (Format: ./truncate.sh STRING [LENGTH] [TRIM_STRING])." >&2
  exit 1
fi

if [ -z "$length" ]; then
  echo "$input"
  exit 0
fi

if [ "$length" -lt "$truncate_string_length" ]; then
  echo "Error: truncate string is shorter or equal to input string." >&2
  exit 1
fi

if [ "$input_length" -gt "$length" ]; then
  truncate_index=$((length - truncate_string_length + 1))
  output="$(cut -c "1-$truncate_index" <<<"$input")"
  output="$output""$truncate_string"
fi

echo "$output"
