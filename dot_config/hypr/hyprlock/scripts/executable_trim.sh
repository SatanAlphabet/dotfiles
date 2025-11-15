#!/usr/bin/env bash

input="$1"
trim_string=${3:-"..."}
input_length=$(wc -c <<<"$input")
trim_string_length=$(wc -c <<<"$trim_string")
length="$2"

output="$input"

if [ -z "$input" ]; then
  echo "Error: string required. (Format: ./trim.sh STRING [LENGTH] [TRIM_STRING])." >&2
  exit 1
fi

if [ -z "$length" ]; then
  echo "$input"
  exit 0
fi

if [ "$length" -lt "$trim_string_length" ]; then
  echo "Error: trim string is shorter or equal to input string." >&2
  exit 1
fi

if [ "$input_length" -gt "$length" ]; then
  trim_index=$((length - trim_string_length + 1))
  output="$(cut -c "1-$trim_index" <<<"$input")"
  output="$output""$trim_string"
fi

echo "$output"
