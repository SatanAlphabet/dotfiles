#!/usr/bin/bash

# Default temperature 4000K if no argument is provided
temp=${1:-4000}

# To force it to stay at the target temp, we set the 'Day' temp 
# to be only 1 unit higher than the 'Night' temp.
high_temp=$((temp + 1))

if pgrep -x wlsunset >/dev/null; then
    pkill wlsunset && notify-send -a "Night Light" -e -t 2000 -r 1 "Night Light Disabled..." -i night-light-symbolic
else
    # We use 0,0 coordinates because they don't matter anymore 
    # since we are forcing the High and Low temps to be the same.
    wlsunset -l 0 -L 0 -t "$temp" -T "$high_temp" >/dev/null 2>&1 &
    
    notify-send -a "Night Light" -e -t 2000 -r 1 "Night Light Enabled..." "Temperature: <b>${temp}K</b>" -i night-light-symbolic
fi

pgrep -x "waybar" >/dev/null && pkill -RTMIN+8 "waybar"