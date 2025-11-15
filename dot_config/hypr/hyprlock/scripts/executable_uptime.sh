#!/usr/bin/env bash

if [ "$(cat /proc/uptime | awk '{printf ("%d",($1/1))}')" -lt 86400 ]; then
  awk '{printf("%dh %02dm\n",($1/60/60%24),($1/60%60))}' /proc/uptime
else
  awk '{printf("%dd %dh %02dm\n",($1/60/60/24),($1/60/60%24),($1/60%60))}' /proc/uptime
fi
