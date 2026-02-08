#!/usr/bin/env bash

# define paths and files
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/niri"
favorites_file="${cache_dir}/landing/cliphist_favorites"
[ -f "$HOME/.cliphist_favorites" ] && favorites_file="$HOME/.cliphist_favorites"

process_deletion() {
  while IFS= read -r line; do
    echo "$line"
    if [[ $line == ":w:i:p:e:"* ]]; then
      main_menu --wipe
      break
    elif [[ $line == ":b:a:r:"* ]]; then
      main_menu --delete
      break
    elif [ -n "$line" ]; then
      cliphist delete <<<"$line"
      notify-send -e "Deleted" "$line"
    fi
  done
  exit 0
}

handle_special_commands() {
  local lines=("$@")
  [ "$CLIPHIST_THEME" ] && local theme_args=("-t" "$CLIPHIST_THEME")
  case "${lines[0]}" in
  ":d:e:l:e:t:e:"*) exec "$0" "${theme_args[@]}" --delete ;;
  ":w:i:p:e:"*) exec "$0" "${theme_args[@]}" --wipe ;;
  ":b:a:r:"* | *":c:o:p:y:"*) exec "$0" "${theme_args[@]}" --copy ;;
  ":f:a:v:"*) exec "$0" "${theme_args[@]}" --favorites ;;
  ":m:a:n:"*) exec "$0" "${theme_args[@]}" -manage-fav ;;
  ":o:p:t:"*) exec "$0" "${theme_args[@]}" ;;
  esac
}

process_selections() {
  # Read the entire input into an array
  mapfile -t lines #! Not POSIX compliant
  # Get the total number of lines
  total_lines=${#lines[@]}

  handle_special_commands "${lines[@]}"

  # process regular clipboard items
  local output=""
  # Iterate over each line in the array
  for ((i = 0; i < total_lines; i++)); do
    local line="${lines[$i]}"
    local decoded_line
    decoded_line="$(echo -e "$line\t" | cliphist decode)"
    if [ $i -lt $((total_lines - 1)) ]; then
      printf -v output '%s%s\n' "$output" "$decoded_line"
    else
      printf -v output '%s%s' "$output" "$decoded_line"
    fi
  done
  echo -n "$output"
}

# check if content is binary and handle accordingly
check_content() {
  local line
  read -r line
  if [[ ${line} == *"[[ binary data"* ]]; then
    cliphist decode <<<"$line" | wl-copy
    local img_idx
    img_idx=$(awk -F '\t' '{print $1}' <<<"$line")
    local temp_preview="$XDG_RUNTIME_DIR/pastebin-preview_${img_idx}"
    wl-paste >"${temp_preview}"
    notify-send -e -a "Pastebin:" "Preview: ${img_idx}" -i "${temp_preview}" -t 2000
    return 1
  fi
}

# execute rofi with common parameters
run_rofi() {
  local placeholder="$1"
  shift
  local rofi_args=(
    -theme-str "entry { placeholder: \"${placeholder}\";} configuration { show-icons: false;}"
    -theme-str "element-icon { enabled: false; }"
    -theme-str "mode-switcher { enabled: false; }"
    -kb-custom-1 "Alt+h"
    -kb-custom-2 "Alt+d"
    -kb-custom-3 "Alt+n"
    -kb-custom-4 "Alt+c"
    -kb-custom-5 "Alt+o"
    -kb-custom-6 "Alt+m"
  )

  if [ "$CLIPHIST_THEME" ]; then
    rofi_args+=(-theme "$CLIPHIST_THEME")
  fi

  pkill rofi || rofi -dmenu "${rofi_args[@]}" "$@"
  local exit_code=$?
  echo $exit_code >&2
  if [ $exit_code -ne 0 ]; then
    case "$exit_code" in
    10) printf ":c:o:p:y:" ;;
    11) printf ":d:e:l:e:t:e:" ;;
    12) printf ":f:a:v:" ;;
    13) printf ":w:i:p:e:" ;;
    14) printf ":o:p:t:" ;;
    15) printf ":m:a:n:" ;;
    esac
  fi
}

# create favorites directory if it doesn't exist
ensure_favorites_dir() {
  local dir
  dir=$(dirname "$favorites_file")
  [ -d "$dir" ] || mkdir -p "$dir"
}

# process favorites file into an array of decoded lines for rofi
prepare_favorites_for_display() {
  if [ ! -f "$favorites_file" ] || [ ! -s "$favorites_file" ]; then
    return 1
  fi

  # read each Base64 encoded favorite as a separate line
  mapfile -t favorites <"$favorites_file"

  # prepare list of representations for rofi
  decoded_lines=()
  for favorite in "${favorites[@]}"; do
    local decoded_favorite
    decoded_favorite=$(echo "$favorite" | base64 --decode)
    # replace newlines with spaces for rofi display
    local single_line_favorite
    single_line_favorite=$(echo "$decoded_favorite" | tr '\n' ' ')
    decoded_lines+=("$single_line_favorite")
  done

  return 0
}

# display clipboard history and copy selected item
show_history() {
  local selected_item
  selected_item=$( (
    echo -e ":f:a:v:\t📌 Favorites"
    echo -e ":o:p:t:\t⚙️ Options"
    cliphist list
  ) | run_rofi " 📜 History..." -multi-select -i -display-columns 2 -selected-row 2)

  [ -n "${selected_item}" ] || exit 0
  handle_special_commands "${selected_item##*$'\n'}"
  if echo -e "${selected_item}" | check_content; then
    process_selections <<<"${selected_item}" | wl-copy
    echo -e "${selected_item}\t" | cliphist delete
  else
    # binary content - handled by check_content
    exit 0
  fi
}

# delete items from clipboard history
delete_items() {
  local selected_item
  selected_item="$(cliphist list | run_rofi " 🗑️ Delete" -multi-select -i -display-columns 2)"
  handle_special_commands "${selected_item##*$'\n'}"
  process_deletion <<<"$selected_item"
}

# favorite clipboard items
view_favorites() {
  prepare_favorites_for_display || {
    notify-send -u low -e "No favorites."
    return
  }

  local selected_favorite
  selected_favorite=$(printf "%s\n" "${decoded_lines[@]}" | run_rofi "📌 View Favorites") || exit 0

  if [ -n "$selected_favorite" ]; then
    # Find the index of the selected favorite
    handle_special_commands "${selected_favorite##*$'\n'}"
    local index
    index=$(printf "%s\n" "${decoded_lines[@]}" | grep -nxF "$selected_favorite" | cut -d: -f1)

    # Use the index to get the Base64 encoded favorite
    if [ -n "$index" ]; then
      local selected_encoded_favorite="${favorites[$((index - 1))]}"
      echo "$selected_encoded_favorite" | base64 --decode | wl-copy
      notify-send -e "Copied to clipboard."
    else
      notify-send -e "Error: Selected favorite not found."
    fi
  fi
}

# add item to favorites
add_to_favorites() {
  ensure_favorites_dir

  local item
  item=$(cliphist list | run_rofi "➕ Add to Favorites...") || exit 0
  handle_special_commands "${item##*$'\n'}"

  if [ -n "$item" ]; then
    local full_item
    full_item=$(echo "$item" | cliphist decode)

    local encoded_item
    encoded_item=$(echo "$full_item" | base64 -w 0)

    # Check if the item is already in the favorites file
    if [ -f "$favorites_file" ] && grep -Fxq "$encoded_item" "$favorites_file"; then
      notify-send -e "Item is already in favorites."
    else
      echo "$encoded_item" >>"$favorites_file"
      notify-send -e "Added to favorites."
    fi
  fi
}

# delete from favorites
delete_from_favorites() {
  prepare_favorites_for_display || {
    notify-send -e "No favorites to remove."
    return
  }

  local selected_favorite
  selected_favorite=$(printf "%s\n" "${decoded_lines[@]}" | run_rofi "➖ Remove from Favorites...") || exit 0
  handle_special_commands "${selected_favorite##*$'\n'}"

  if [ -n "$selected_favorite" ]; then
    local index
    index=$(printf "%s\n" "${decoded_lines[@]}" | grep -nxF "$selected_favorite" | cut -d: -f1)

    if [ -n "$index" ]; then
      local selected_encoded_favorite="${favorites[$((index - 1))]}"

      # Handle case where only one item is present
      if [ "$(wc -l <"$favorites_file")" -eq 1 ]; then
        : >"$favorites_file"
      else
        grep -vF -x "$selected_encoded_favorite" "$favorites_file" >"${favorites_file}.tmp" &&
          mv "${favorites_file}.tmp" "$favorites_file"
      fi
      notify-send -e "Item removed from favorites."
    else
      notify-send -e "Error: Selected favorite not found."
    fi
  fi
}

# clear all favorites
clear_favorites() {
  if [ -f "$favorites_file" ] && [ -s "$favorites_file" ]; then
    local confirm
    confirm=$(echo -e "Yes\nNo" | run_rofi "☢️ Clear All Favorites?") || exit 0
    handle_special_commands "${confirm##*$'\n'}"

    if [ "$confirm" = "Yes" ]; then
      : >"$favorites_file"
      notify-send -e "All favorites have been deleted."
    fi
  else
    notify-send -e "No favorites to delete."
  fi
}

# manage favorites
manage_favorites() {
  local manage_action
  manage_action=$(echo -e "Add to Favorites\nDelete from Favorites\nClear All Favorites" | run_rofi "📓 Manage Favorites") || exit 0
  handle_special_commands "${manage_action##*$'\n'}"

  case "${manage_action}" in
  "Add to Favorites")
    add_to_favorites
    ;;
  "Delete from Favorites")
    delete_from_favorites
    ;;
  "Clear All Favorites")
    clear_favorites
    ;;
  *)
    [ -n "${manage_action}" ] || return 0
    echo "Invalid action"
    exit 1
    ;;
  esac
}

# clear clipboard history
clear_history() {
  local confirm
  confirm=$(echo -e "Yes\nNo" | run_rofi "☢️ Clear Clipboard History?")
  handle_special_commands "${confirm##*$'\n'}"

  if [ "$confirm" = "Yes" ]; then
    cliphist wipe
    notify-send -e "Clipboard history cleared."
  fi
}

# show help message
show_help() {
  cat <<EOF
Options:
  -t  | --theme <theme>                  Select rofi theme to use
  -c  | --copy      | History            Show clipboard history and copy selected item
  -d  | --delete    | Delete             Delete selected item from clipboard history
  -f  | --favorites | View Favorites     View favorite clipboard items
  -mf | -manage-fav | Manage Favorites   Manage favorite clipboard items
  -w  | --wipe      | Clear History      Clear clipboard history
  -h  | --help      | Help               Display this help message
EOF
  exit 0
}

main_menu_options() {
  cat <<-EOF
		History:::<sub>(Alt+C)</sub>
		Delete Item:::<sub>(Alt+D)</sub>
		Clear History:::<sub>(Alt+W)</sub>
		View Favorites:::<sub>(Alt+N)</sub>
		Manage Favorites:::<sub>(Alt+M)</sub>
	EOF
}

main_menu() {

  local main_action
  # show main menu if no arguments are passed
  if [ $# -eq 0 ]; then
    main_action=$(
      main_menu_options | run_rofi "🔎 Choose action (Alt+O)" \
        -display-column-separator ":::" \
        -display-columns 1,2 \
        -markup-rows
    )
  else
    main_action="$1"
  fi

  handle_special_commands "${main_action##*$'\n'}"
  main_action="${main_action%%:::*}"

  # process user selection
  case "${main_action}" in
  -c | --copy | "History")
    show_history "$@"
    ;;
  -d | --delete | "Delete Item")
    delete_items
    ;;
  -f | --favorites | "View Favorites")
    view_favorites "$@"
    ;;
  -mf | -manage-fav | "Manage Favorites")
    manage_favorites
    ;;
  -w | --wipe | "Clear History")
    clear_history
    ;;
  -h | --help | *)
    [ -z "$main_action" ] && exit 0
    show_help
    ;;
  esac
}

while true; do
  case "$1" in
  -t | --theme)
    CLIPHIST_THEME="$2"
    shift 2
    ;;
  *)
    main_menu "$@"
    break
    ;;
  esac
done
