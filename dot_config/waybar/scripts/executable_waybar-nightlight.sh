#!/bin/bash

if pgrep -x "wlsunset" >/dev/null; then
  echo '{ "text": "Active", "alt": "active", "class": "active" }'
else
  echo '{ "text": "Disabled" }'
fi
