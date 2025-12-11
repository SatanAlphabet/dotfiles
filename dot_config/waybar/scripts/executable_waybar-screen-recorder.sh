#!/usr/bin/env bash

if pgrep -f gpu-screen-recorder >/dev/null; then
  echo '{ "text": "Recording", "alt": "recording", "class": "recording" }'
else
  echo '{ "text": "Stopped" }'
fi
