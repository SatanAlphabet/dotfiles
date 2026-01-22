#!/usr/bin/env bash

ORANGE='\033[0;33m'
NC='\033[0m' # No Color

pkg_text=" - System packages updated."
flatpak_text=" - Flatpak packages updated."
post_upd_text=" - Post-update checks completed."

upd_command="pacman" # Fallback when no alternative package managers are detected

upd_args=(-Syu)
flatpak_args=(-u --system)
post_upd_args=(-i "sddm.service" -i "gdm.service") # Ignore display manager services to avoid nuking the current session

_confirm_prompt() {
  local response
  echo -n -e "Skip confirmation prompts? [y/N] "
  read -r response

  if [[ "$response" =~ ^[Yy]$ ]]; then
    SKIP_PROMPT=1
  elif [[ "$response" =~ ^[Nn]|^\s*$ ]]; then
    SKIP_PROMPT=0
  else
    _confirm_prompt
  fi
}

_uodate_system() {

  if [ "$SKIP_PROMPT" -eq 1 ]; then
    upd_args+=(--noconfirm)
    flatpak_args+=(-y)
    post_upd_args+=(-a)
    echo -e "${ORANGE}===>${NC}  Skipping confirmation prompts..."
  fi

  echo -e "${ORANGE}===>${NC}  Beginning system update...\n"

  pm_list=(paru yay)

  for pm in "${pm_list[@]}"; do
    if which "$pm" >/dev/null 2>&1; then
      upd_command="$pm"
      break
    fi
  done

  if ! $upd_command "${upd_args[@]}"; then
    failed_update=true
    pkg_text=" [!] Failed to update system packages."
  fi

  echo -e "\n${ORANGE}===>${NC}  Checking for flatpak updates...\n"

  if ! flatpak update "${flatpak_args[@]}"; then
    failed_update=true
    flatpak_text=" [!] Failed to update flatpak packages."
  fi

  echo -e "\n${ORANGE}===>${NC}  Running post-installation checks...\n"

  if ! sudo checkservices "${post_upd_args[@]}"; then
    failed_update=true
    post_upd_text=" [!] Failed to run post-service checks."
  fi

  notif_msg="$pkg_text\n$flatpak_text\n$post_upd_text"

  if [ "$failed_update" ]; then
    notify-send 'System update failed...' "$notif_msg" -a 'System Update' -u critical -i dialog-warning-symbolic
  else
    notify-send 'System update completed...' "$notif_msg" -a 'System Update' -i object-select-symbolic
  fi

  read -r -n 1 -p 'Press any key to exit...'
}

while true; do
  case "$1" in
  --confirm)
    SKIP_PROMPT=0
    shift
    ;;
  --no-confirm | -y)
    SKIP_PROMPT=1
    shift
    ;;
  *)
    fastfetch.sh 2>/dev/null || fastfetch
    [ -z "$SKIP_PROMPT" ] && _confirm_prompt
    _uodate_system
    break
    ;;
  esac
done
