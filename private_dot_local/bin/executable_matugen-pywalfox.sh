#!/usr/bin/env bash
mode="$1"

case "$mode" in
"dark")
  pywalfox dark
  ;;
"light")
  pywalfox light
  ;;
*)
  echo "$0: Invalid mode" >&2
  exit 1
  ;;
esac

pywalfox update
