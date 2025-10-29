#!/bin/bash

if pgrep -f "systemd-inhibit --what=idle sleep infinity" >/dev/null; then
  echo '{ "text": "Active", "alt": "active", "class": "active" }'
else
  echo '{ "text": "Disabled" }'
fi
