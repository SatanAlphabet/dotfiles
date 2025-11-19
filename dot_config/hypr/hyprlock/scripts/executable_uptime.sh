#!/usr/bin/env bash

uptime="$(cat /proc/uptime | awk '{printf ("%d",($1/1))}')"

if [ "$uptime" -lt 3600 ]; then
  awk '{printf("%dm\n",($1/60%60))}' <<<"$uptime"
elif [ "$uptime" -lt 86400 ]; then
  awk '{printf("%dh %02dm\n",($1/60/60%24),($1/60%60))}' <<<"$uptime"
else
  awk '{printf("%dd %dh %02dm\n",($1/60/60/24),($1/60/60%24),($1/60%60))}' <<<"$uptime"
fi
