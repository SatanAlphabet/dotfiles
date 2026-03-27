#!/usr/bin/env bash

source /etc/os-release

case "$NAME" in
"Arch Linux")
  class="arch"
  alt="arch"
  ;;
"CachyOS Linux")
  class="cachyos"
  alt="cachyos"
  ;;
"EndeavourOS")
  class="endeavouros"
  alt="endeavouros"
  ;;
"Manjaro Linux")
  class="manjaro"
  alt="manjaro"
  ;;
*)
  class="unknown"
  alt="unknown"
  ;;
esac

echo "{ \"text\": \"$NAME\", \"class\": \"$class\", \"alt\": \"$alt\" }"
