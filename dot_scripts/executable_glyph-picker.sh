#!/usr/bin/env bash

# shellcheck disable=SC1090
#if ! source "$(command -v hyde-shell)"; then
#  echo "[wallbash] code :: Error: hyde-shell not found."
#  echo "[wallbash] code :: Is HyDE installed?"
#  exit 1
#fi

#* This glyph Data is from `https://www.nerdfonts.com/cheat-sheet`
#* I don't own any of it
#TODO:   Needed a way to fetch the glyph from the NerdFonts source.
#TODO:    find a way make the  DB update
#TODO:    make the update Script run on User space

# Define paths and files
glyph_dir=${HYDE_DATA_HOME:-$HOME/.local/share/niri}
glyph_data="${glyph_dir}/glyph.db"
cache_dir="${HYDE_CACHE_HOME:-$HOME/.cache/niri}"
recent_data="${cache_dir}/landing/show_glyph.recent"

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

# rofi settings
setup_rofi_config() {
  # font scale
  local font_scale="${ROFI_GLYPH_SCALE}"
  [[ "${font_scale}" =~ ^[0-9]+$ ]] || font_scale=${ROFI_SCALE:-10}

  # font name
  local font_name=${ROFI_GLYPH_FONT:-$ROFI_FONT}
  font_name=${font_name:-$(get_hyprConf "MENU_FONT")}
  font_name=${font_name:-$(get_hyprConf "FONT")}

  # rofi font override
  font_override="* {font: \"${font_name:-"JetBrainsMono Nerd Font Propo"} ${font_scale}\";}"

  # border settings
  local hypr_border=${hypr_border:-2}
  local wind_border=$((hypr_border * 3 / 2))
  local elem_border=$((hypr_border == 0 ? 5 : hypr_border))

  # rofi position
  rofi_position=$(get_rofi_pos)

  # border width
  local hypr_width=${hypr_width:-2}
  r_override="window{border:2px;border-radius:12px;}wallbox{border-radius:8px;} element{border-radius:2px;}"
}

# rofi menu, get selection
get_glyph_selection() {
  rofi_running=$(pidof rofi)

  if [ "$rofi_running" -ne 0 ]; then
    pkill rofi
  else
    echo "${unique_entries}" | rofi -dmenu -multi-select -i \
      -theme-str "entry { placeholder: \" 🔣 Glyph\";} configuration { show-icons: false; }" \
      -theme "${ROFI_GLYPH_STYLE:-style_3}"
  fi
}

main() {
  # create recent data file if it doesn't exist
  if [[ ! -f "${recent_data}" ]]; then
    mkdir -p "$(dirname "${recent_data}")"
    echo -e " \tArch linux - I use Arch, BTW" >"${recent_data}"
  fi

  # read recent and main entries
  local recent_entries
  recent_entries=$(cat "${recent_data}")
  local main_entries
  main_entries=$(cat "${glyph_data}")

  # combine entries and remove duplicates
  combined_entries="${recent_entries}\n${main_entries}"
  unique_entries=$(echo -e "${combined_entries}" | awk '!seen[$0]++')

  # rofi config
  setup_rofi_config

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
