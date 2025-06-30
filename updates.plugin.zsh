# sysupdate.plugin.zsh

# Helper for colored headers
print_header() {
  echo -e "\n\033[1;34m==> $1\033[0m"
}

# Prompt for confirmation
confirm() {
  read "?$1 Proceed? [y/N]: " ans
  [[ "$ans" == [Yy]* ]]
}

# Main update function
update() {
  local target="$1"
  local interactive="$2"

  if [[ -z "$target" ]]; then
    echo "❌ Usage: update [dnf|flatpak|snap|all] [--interactive]"
    return 1
  fi

  case "$target" in
    dnf)
      if [[ "$interactive" == "--interactive" ]]; then
        confirm "Update DNF packages?" || { echo "❌ Skipped DNF"; return; }
      fi
      print_header "Updating DNF packages..."
      sudo dnf upgrade --refresh -y
      ;;
    flatpak)
      if [[ "$interactive" == "--interactive" ]]; then
        confirm "Update Flatpak packages?" || { echo "❌ Skipped Flatpak"; return; }
      fi
      print_header "Updating Flatpak packages..."
      flatpak update -y
      ;;
    snap)
      if [[ "$interactive" == "--interactive" ]]; then
        confirm "Update Snap packages?" || { echo "❌ Skipped Snap"; return; }
      fi
      print_header "Updating Snap packages..."
      sudo snap refresh
      ;;
    all)
      update dnf "$interactive"
      update flatpak "$interactive"
      update snap "$interactive"
      ;;
    *)
      echo "❌ Unknown option: $target"
      echo "Usage: update [dnf|flatpak|snap|all] [--interactive]"
      return 1
      ;;
  esac
}
