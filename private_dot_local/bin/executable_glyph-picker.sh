#!/usr/bin/env bash

# shellcheck disable=SC1090

# Define paths and files
glyph_dir="$HOME/.local/share/niri"
glyph_data="${glyph_dir}/glyph.db"
cache_dir="$HOME/.cache/niri"
recent_data="${cache_dir}/landing/show_glyph.recent"
rofi_style="menu"

# checks if a glyph is valid, functionally identical logic to #344
is_valid_glyph() {
  local glyph="$1"

  # return false if glyph is empty or unique_entries is not set
  [[ -z "${glyph}" || -z "${unique_entries}" ]] && return 1

  # uses bash's pattern matching instead of echo and grep
  [[ $'\n'"${unique_entries}"$'\n' == *$'\n'"${glyph}"$'\n'* ]]
}

# save selected glyph to recent list, remove duplicates
save_recent() {
  is_valid_glyph "${data_glyph}" || return 0
  awk -v var="$data_glyph" 'BEGIN{print var} {print}' "${recent_data}" >temp && mv temp "${recent_data}"
  awk 'NF' "${recent_data}" | awk '!seen[$0]++' >temp && mv temp "${recent_data}"
}

# Parse command line arguments
parse_arguments() {
  while (($# > 0)); do
    case $1 in
    --style | -s)
      if (($# > 1)); then
        rofi_style="$2"
        shift # Consume the value argument
      else
        echo "WARNING: ""--style needs argument"
        shift
      fi
      ;;
    --rasi)
      [[ -z ${2} ]] && echo "ERROR: ""--rasi requires an file.rasi config file" && exit 1
      shift
      ;;
    -*)
      cat <<HELP
Usage:
--style <style_name>     Change Glyph style
HELP

      exit 0
      ;;
    esac
    shift # Shift off the current option being processed
  done
}

# rofi menu, get selection
get_glyph_selection() {
  rofi_running=$(pidof rofi)

  if [ -n "$rofi_running" ]; then
    pkill -SIGUSR2 rofi
  else
    local style_type=${rofi_style:-"menu"}
    echo "${unique_entries}" | rofi -dmenu -multi-select -i \
      -theme-str "entry { placeholder: \" 🔣 Glyph\";} configuration { show-icons: false; }" \
      -theme "${style_type}"
  fi
}

main() {
  parse_arguments "$@"
  # create recent data file if it doesn't exist
  if [[ ! -f "${recent_data}" ]]; then
    mkdir -p "$(dirname "${recent_data}")"
    echo -e " \tArch linux - I use Arch, BTW" >"${recent_data}"
  fi

  # read recent and main entries
  local recent_entries
  recent_entries=$(cat "${recent_data}")
  local main_entries
  main_entries=$(cat "${glyph_data}")

  # combine entries and remove duplicates
  combined_entries="${recent_entries}\n${main_entries}"
  unique_entries=$(echo -e "${combined_entries}" | awk '!seen[$0]++')

  # get glyph selection from rofi
  data_glyph=$(get_glyph_selection)

  # avoid copying typed text to clipboard, only copy valid glyph
  is_valid_glyph "${data_glyph}" || exit 0

  # extract and copy selected glyph(s)
  local sel_glyphs
  sel_glyphs=$(echo "${data_glyph}" | cut -d' ' -f1 | tr -d '\n\r')

  wl-copy "${sel_glyphs}"
  paste_string "${@}"
}

# exit trap to save recent glyphs
trap save_recent EXIT

# run main function
main "$@"
