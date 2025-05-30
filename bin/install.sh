#!/usr/bin/env bash
set -euo pipefail

# File: bin/install.sh
# Location: $DEVKITX_REPO/bin/install.sh
#
# Description:
#   Global installer script for DevKitXsh.
#   Clones or downloads the latest DevKitXsh into ~/.devkitxsh and bootstraps the environment.
#
# Usage:
#   bash bin/install.sh [--quiet|-q] [--plain]
#
# Flags:
#   --quiet, -q   Suppress informational output (errors still shown)
#   --plain       Disable emoji output in messages
#
# Environment Variables:
#   DEVKITX_DIR     Path where devkitx gets installed (default: ~/.devkitx)
#   DEVKITXSH_DIR   Path where devkitxsh gets installed (default: ~/.devkitxsh)

# Paths
DEVKITXSH_DIR="${DEVKITXSH_DIR:-$HOME/.devkitxsh}"
DEVKITXSH_DIR="$(printf '%s\n' "$(realpath "$DEVKITXSH_DIR" 2>/dev/null || echo "$DEVKITXSH_DIR")")"

# Repository config
DEVKITX_BRANCH="${DEVKITX_BRANCH:-main}"
DEVKITX_REPO_URL="${DEVKITX_REPO_URL:-https://github.com/ctrlmaniac/devkitx.git}"
DEVKITX_BRANCH="main"

# QUIET=false
# PLAIN=false

print_banner() {
	cat <<'EOF'

 ▄▄▄▄▄                         ▄▄   ▄▄▄     ██               ▄▄▄  ▄▄▄            ▄▄
 ██▀▀▀██                       ██  ██▀      ▀▀       ██       ██▄▄██             ██
 ██    ██   ▄████▄   ██▄  ▄██  ██▄██      ████     ███████     ████    ▄▄█████▄  ██▄████▄
 ██    ██  ██▄▄▄▄██   ██  ██   █████        ██       ██         ██     ██▄▄▄▄ ▀  ██▀   ██
 ██    ██  ██▀▀▀▀▀▀   ▀█▄▄█▀   ██  ██▄      ██       ██        ████     ▀▀▀▀██▄  ██    ██
 ██▄▄▄██   ▀██▄▄▄▄█    ████    ██   ██▄  ▄▄▄██▄▄▄    ██▄▄▄    ██  ██   █▄▄▄▄▄██  ██    ██
 ▀▀▀▀▀       ▀▀▀▀▀      ▀▀     ▀▀    ▀▀  ▀▀▀▀▀▀▀▀     ▀▀▀▀   ▀▀▀  ▀▀▀   ▀▀▀▀▀▀   ▀▀    ▀▀

EOF
}

# while (("$#")); do
# 	case "$1" in
# 	--quiet | -q)
# 		QUIET=true
# 		shift
# 		;;
# 	--plain)
# 		PLAIN=true
# 		shift
# 		;;
# 	*)
# 		log_error "Unknown option: $1"
# 		exit 1
# 		;;
# 	esac
# done

# Check for sudo privileges
require_sudo() {
	if sudo -v >/dev/null 2>&1; then
		return 0
	fi

	printf "[WARN] Sudo privileges are required. Attempting to gain privileges..."

	if command -v sudo >/dev/null 2>&1; then
		if sudo; then
			if sudo -v >/dev/null 2>&1; then
				printf "[OK] Sudo privileges granted.\n"
				return 0
			fi
		fi
	fi

	printf "[ERROR] Failed to obtain sudo privileges.\n"
	printf "	    Please log in as a user with sudo rights and try again.\n" >&2
	exit 1
}

download_devkitxsh() {
	printf "\n[INFO] Downloading DevKitXsh to: %s...\n\n" "$DEVKITXSH_DIR"

	if [[ -d "$DEVKITXSH_DIR" ]]; then
		printf "[INFO] DevKitXsh already installed at %s\n" "$DEVKITXSH_DIR"
		return 0
	fi

	printf "[INFO] Cloning DevKitXsh from GitHub from %s...\n" "$DEVKITX_REPO_URL"

	mkdir -p "$DEVKITXSH_DIR"
	git init "$DEVKITXSH_DIR" >/dev/null
	cd "$DEVKITXSH_DIR"

	git remote add origin "$DEVKITX_REPO_URL"
	git config core.sparseCheckout true
	printf "%s\n" "devkitxsh/*" >.git/info/sparse-checkout
	git pull origin "$DEVKITX_BRANCH"

	# Remove Git tracking to avoid accidental commits
	rm -rf .git

	printf "[OK] DevKitXsh cloned successfully to: %s\n\n" "$DEVKITXSH_DIR"
}

install_devkitxsh() {
	printf "[STEP] Installing DevKitXsh...\n"

	if [ -f "$DEVKITXSH_DIR/install.sh" ]; then
		bash "$DEVKITXSH_DIR/install.sh"
	else
		printf "[ERROR] Unable to install DevKitXsh."
		printf "		Aborting...\n"
		exit 1
	fi

	printf "\n"
}

main() {
	print_banner

	require_sudo

	download_devkitxsh

	install_devkitxsh
}

main
