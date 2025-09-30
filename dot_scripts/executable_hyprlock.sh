#!/usr/bin/bash

confDir="${confDir:-$XDG_CONFIG_HOME}"
cacheDir="${HYDE_CACHE_HOME:-"${XDG_CACHE_HOME}/niri"}"

USAGE() {
  cat <<EOF
    Usage: $(basename "${0}") --[arg]

    arguments:
      --mpris <player>   - Handles mpris thumbnail generation
                            : \$MPRIS_IMAGE
      --profile          - Generates the profile picture
                            : \$PROFILE_IMAGE
      --art              - Prints the path to the mpris art"
                            : \$MPRIS_ART
      --help       -h    - Displays this help message"
EOF
}

fn_profile() {
  local profilePath="${cacheDir}/landing/profile"
  if [ -f "$HOME/.face.icon" ]; then
    cp "$HOME/.face.icon" "${profilePath}.png"
  fi
  return 0
}

fn_mpris() {
  local player=${1:-$(playerctl --list-all 2>/dev/null | head -n 1)}
  player_status="$(playerctl -p "${player}" status 2>/dev/null)"
  if [[ "${player_status}" == "Playing" ]]; then
    playerctl -p "${player}" metadata --format "{{xesam:title}} $(mpris_icon "${player}")  {{xesam:artist}}"
  else
    exit 1 # let the other fallback command run
  fi
}

mpris_icon() {

  local player=${1:-default}
  declare -A player_dict=(
    ["default"]=""
    ["spotify"]=""
    ["firefox"]=""
    ["vlc"]="嗢"
    ["google-chrome"]=""
    ["opera"]=""
    ["brave"]=""
  )

  for key in "${!player_dict[@]}"; do
    if [[ ${player} == "$key"* ]]; then
      echo "${player_dict[$key]}"
      return
    fi
  done
  echo "" # Default icon if no match is found

}

fn_art() {
  echo "${cacheDir}/landing/mpris.art"
}

# Define long options
LONGOPTS="profile,mpris:,art,help"

# Parse options
PARSED=$(
  if ! getopt --options shb --longoptions $LONGOPTS --name "$0" -- "$@"; then
    exit 2
  fi
)

# Apply parsed options
eval set -- "$PARSED"

while true; do
  case "$1" in
  background | --background | -b)
    fn_background
    exit 0
    ;;
  profile | --profile)
    fn_profile
    exit 0
    ;;
  mpris | --mpris)
    fn_mpris "${2}"
    exit 0
    ;;
  art | --art)
    fn_art
    exit 0
    ;;
  help | --help | -h)
    USAGE
    exit 0
    ;;
  --)
    shift
    break
    ;;
  *)
    break
    ;;
  esac
  shift
done
