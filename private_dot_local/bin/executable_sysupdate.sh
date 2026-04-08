#!/usr/bin/env bash

NC='\033[0m' # No Color
BOLD='\033[1m'

# Regular Colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Bold
BLACK_BOLD='\033[1;30m'
RED_BOLD='\033[1;31m'
GREEN_BOLD='\033[1;32m'
YELLOW_BOLD='\033[1;33m'
BLUE_BOLD='\033[1;34m'
PURPLE_BOLD='\033[1;35m'
CYAN_BOLD='\033[1;36m'
WHITE_BOLD='\033[1;37m'

# Background
ON_BLACK='\033[40m'
ON_RED='\033[41m'
ON_GREEN='\033[42m'
ON_YELLOW='\033[43m'
ON_BLUE='\033[44m'
ON_PURPLE='\033[45m'
ON_CYAN='\033[46m'
ON_WHITE='\033[47m'

if ! source /etc/os-release 2>/dev/null; then
  echo -e "${RED_BOLD}ERROR${NC}${BOLD}: Cannot source OS info.${NC}"
fi

priv_esc_command_list=(sudo doas run0)
for cmd in "${priv_esc_command_list[@]}"; do
  if which "$cmd" >/dev/null 2>&1; then
    priv_esc_command="$cmd"
    break
  fi
done

success_text=()
failed_text=()

_confirm_prompt() {
  local response
  echo -n -e "${BOLD}Skip confirmation prompts? [y/N]${NC} "
  read -r response

  if [[ "$response" =~ ^[Yy]$|^[Yy][Ee][Ss]$ ]]; then
    SKIP_PROMPT=true
  elif [[ "$response" =~ ^[Nn]|^[Nn]^[Oo]$|^\s*$ ]]; then
    SKIP_PROMPT=false
  else
    _confirm_prompt
  fi
}

_update_package() {
  if [[ "$ID_LIKE" = "arch" || "$ID" = "arch" ]]; then
    local upd_command="pacman" # Fallback when no alternative package managers are detected
    local pm_list=(paru yay)

    for pm in "${pm_list[@]}"; do
      if which "$pm" >/dev/null 2>&1; then
        upd_command="$pm"
        break
      fi
    done
    local upd_args=(-Syu)
    $SKIP_PROMPT && upd_args+=(--noconfirm)
  else
    echo -e "${RED_BOLD}===>${NC}  ${BOLD}Unsupported distro detected.${NC}"
    echo -e "${RED_BOLD}===>${NC}  ${BOLD}Skipping system upgrades...${NC}"
    return 0
  fi

  echo -e "${BLUE_BOLD}===>${NC}  ${BOLD}Beginning system update...${NC}\n"
  if "$upd_command" "${upd_args[@]}"; then
    success_text+=("System packages updated.")
  else
    failed_update=true
    failed_text+=("<b>[!] Failed to update system packages.</b>")
  fi
}

_update_flatpak() {
  if ! which flatpak >/dev/null 2>&1; then
    echo -e "${YELLOW_BOLD}===>${NC}  ${BOLD}Flatpak is not installed.${NC}"
    echo -e "${YELLOW_BOLD}===>${NC}  ${BOLD}Skipping flatpak upgrades...${NC}"
    return 0
  fi
  local flatpak_args=(-u --system)
  $SKIP_PROMPT && flatpak_args+=(-y)

  echo -e "\n${BLUE_BOLD}===>${NC}  ${BOLD}Checking for flatpak updates...${NC}\n"
  if flatpak update "${flatpak_args[@]}"; then
    success_text+=("Flatpak packages updated.")
  else
    failed_update=true
    failed_text+=("<b>[!] Failed to update flatpak packages.</b>")
  fi
}

_post_update_check() {
  if [[ "$ID_LIKE" = "arch" || "$ID" = "arch" ]]; then
    local post_upd_command=("$priv_esc_command" checkservices)
    local post_upd_args=(-i "sddm.service" -i "gdm.service") # Ignore display manager services to avoid nuking the current session
    $SKIP_PROMPT && post_upd_args+=(-a)
  else
    echo -e "${RED_BOLD}===>${NC}  ${BOLD}Unsupported distro detected.${NC}"
    echo -e "${RED_BOLD}===>${NC}  ${BOLD}Skipping post-update checks...${NC}"
    return 0
  fi

  echo -e "\n${BLUE_BOLD}===>${NC}  ${BOLD}Running post-update checks...${NC}\n"
  if "${post_upd_command[@]}" "${post_upd_args[@]}"; then
    success_text+=("Post-update checks completed.")
  else
    failed_update=true
    failed_text+=("<b>[!] Failed to run post-service checks.</b>")
  fi
}

_post_update_notify() {
  local IFS=$'\n'
  notif_msg=("${success_text[@]}" "${failed_text[@]}")

  if [ "$failed_update" ]; then
    notify-send 'System update failed...' "${notif_msg[*]}" -a 'System Update' -u critical -i dialog-warning-symbolic
  else
    notify-send 'System update completed...' "${notif_msg[*]}" -a 'System Update' -i object-select-symbolic
  fi
}

_update_system() {

  if $SKIP_PROMPT; then
    echo -e "${YELLOW_BOLD}===>${NC}  ${BOLD}Skipping confirmation prompts...${NC}"
  fi

  _update_package
  _update_flatpak
  _post_update_check
  _post_update_notify
  read -r -n 1 -p 'Press any key to exit...'
}

while true; do
  case "$1" in
  --confirm)
    SKIP_PROMPT=false
    shift
    ;;
  --no-confirm | -y)
    SKIP_PROMPT=true
    shift
    ;;
  *)
    fastfetch
    [ -z "$SKIP_PROMPT" ] && _confirm_prompt
    _update_system
    break
    ;;
  esac
done
