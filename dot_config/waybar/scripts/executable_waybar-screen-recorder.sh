#!/usr/bin/env bash

recording_lockfile="/tmp/screen-recording"

if [ -e "$recording_lockfile" ]; then
  echo '{ "text": "Recording", "alt": "recording", "class": "recording" }'
else
  echo '{ "text": "Stopped" }'
fi
