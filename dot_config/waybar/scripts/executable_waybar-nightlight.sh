#!/bin/bash

if pgrep -x "wlsunset" >/dev/null; then
  echo '{ "text": "󰽥", "tooltip": "Night Light: <b>ON</b>", "class": "active" }'
else
  echo '{ "text": "󰖨", "tooltip": "Night Light: <b>OFF</b>" }'
fi
