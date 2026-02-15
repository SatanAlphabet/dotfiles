#!/usr/bin/env bash

uptime="$(cat /proc/uptime | awk '{printf ("%d",($1/1))}')"

get_uptime() {
  local day_label="d"
  local hour_label="h"
  local min_label="m"
  days=$((uptime / 86400))
  remainder=$((uptime % 86400))
  hours=$((remainder / 3600))
  remainder=$((remainder % 3600))
  minutes=$((remainder / 60))

  if [ $PRETTY_FORMAT ]; then
    [ $days -gt 1 ] && day_label=" Days" || day_label=" Day"
    [ $hours -gt 1 ] && hour_label=" Hours" || hour_label=" Hour"
    [ $minutes -gt 1 ] && min_label=" Minutes" || min_label=" Minute"
  fi

  output="$minutes$min_label"
  [ $hours -gt 0 ] && output="$hours$hour_label $output"
  [ $days -gt 0 ] && output="$days$day_label $output"

  echo "$output"
}

while true; do
  case "$1" in
  -p | --pretty)
    PRETTY_FORMAT=true
    shift
    ;;
  *)
    get_uptime
    break
    ;;
  esac
done
