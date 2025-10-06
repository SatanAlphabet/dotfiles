#!/usr/bin/env bash

# Define paths and files
emoji_dir=${HYDE_DATA_HOME:-$HOME/.local/share/niri}
emoji_data="${emoji_dir}/emoji.db"
cache_dir="${HYDE_CACHE_HOME:-$HOME/.cache/niri}"
recent_data="${cache_dir}/landing/show_emoji.recent"

# checks if an emoji entry is valid
is_valid_emoji() {
  local emoji_entry="$1"

  # return false if emoji is empty or unique_entries is not set
  [[ -z "${emoji_entry}" || -z "${unique_entries}" ]] && return 1

  # uses bash's pattern matching instead of echo and grep
  echo -e "${unique_entries}" | grep -Fxq "${emoji_entry}"
}

# save selected emoji to recent list, remove duplicates
save_recent() {
  is_valid_emoji "${data_emoji}" || return 0
  awk -v var="$data_emoji" 'BEGIN{print var} {print}' "${recent_data}" >temp && mv temp "${recent_data}"
  awk 'NF' "${recent_data}" | awk '!seen[$0]++' >temp && mv temp "${recent_data}"
}

# rofi settings
setup_rofi_config() {
  # font scale
  local font_scale="${ROFI_EMOJI_SCALE}"
  [[ "${font_scale}" =~ ^[0-9]+$ ]] || font_scale=${ROFI_SCALE:-10}

  # font name
  local font_name=${ROFI_EMOJI_FONT:-$ROFI_FONT}
  font_name=${font_name:-$(get_hyprConf "MENU_FONT")}
  font_name=${font_name:-$(get_hyprConf "FONT")}
}

# Parse command line arguments
parse_arguments() {
  while (($# > 0)); do
    case $1 in
    --style | -s)
      if (($# > 1)); then
        emoji_style="$2"
        shift # Consume the value argument
      else
        print_log +y "[warn] " "--style needs argument"
        emoji_style="style_2"
        shift
      fi
      ;;
    --rasi)
      [[ -z ${2} ]] && print_log +r "[error] " +y "--rasi requires an file.rasi config file" && exit 1
      use_rofile=${2}
      shift
      ;;
    -*)
      cat <<HELP
Usage:
--style <style_name>     Change Emoji style
HELP

      exit 0
      ;;
    esac
    shift # Shift off the current option being processed
  done
}

# Get emoji selection from rofi
get_emoji_selection() {
  rofi_running=$(pidof rofi)

  if [ -n "$rofi_running" ]; then
    pkill -SIGUSR2 rofi
  else
    if [[ -n ${use_rofile} ]]; then
      echo "${unique_entries}" | rofi -dmenu -i -config "${use_rofile}"
    else
      local style_type="${emoji_style}"
      echo "${unique_entries}" | rofi -dmenu -multi-select -i \
        -theme-str "entry { placeholder: \" 🔎 Emoji\";}" \
        -theme-str "configuration {show-icons: false;}" \
        -theme "${style_type:-style_2}"
    fi
  fi
}

main() {
  # Parse command line arguments
  parse_arguments "$@"

  # create recent data file if it doesn't exist
  if [[ ! -f "${recent_data}" ]]; then
    mkdir -p "$(dirname "${recent_data}")"
    echo " Arch linux - I use Arch, BTW" >"${recent_data}"
  fi

  # read recent and main entries
  local recent_entries main_entries
  recent_entries=$(cat "${recent_data}")
  main_entries=$(cat "${emoji_data}")

  # combine entries and remove duplicates
  combined_entries="${recent_entries}\n${main_entries}"
  unique_entries=$(echo -e "${combined_entries}" | awk '!seen[$0]++')

  # rofi config
  setup_rofi_config

  # get emoji selection from rofi
  data_emoji=$(get_emoji_selection)

  # avoid copying typed text to clipboard, only copy valid emoji
  [ -z "${data_emoji}" ] && exit 0

  # extract and copy selected emoji(s)
  local sel_emoji
  sel_emoji=$(printf "%s" "${data_emoji}" | cut -d' ' -f1 | tr -d '\n\r')

  wl-copy "${sel_emoji}"
  paste_string "${@}"
}

# exit trap to save recent emojis
trap save_recent EXIT

# run main function
main "$@"
