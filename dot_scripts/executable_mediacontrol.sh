status=$(playerctl status)

playerctl play-pause
if [[ ${status} = 'Playing' ]]; then
  notify-send -e -r 2 -t 1500 "Paused media..."
elif [[ ${status} = 'Paused' ]]; then
  notify-send -e -r 2 -t 1500 "Playing media..."
else
  notify-send -e -r 2 -t 1500 "No media found..."
fi
