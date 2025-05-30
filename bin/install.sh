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
#   DEVKITXSH_DIR   Path where devkitxsh gets installed (default: ~/.devkitxsh)
#   DEVKITX_BRANCH  Git branch/tag to checkout (default: main)
#   DEVKITX_REPO_URL Git repository URL (default: https://github.com/ctrlmaniac/devkitx.git)

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${YELLOW}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*"; }
log_warn() { echo -e "${ORANGE}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERR]${NC} $*" >&2; }

# Default variables
DEVKITXSH_DIR="${DEVKITXSH_DIR:-$HOME/.devkitxsh}"
DEVKITXSH_DIR="$(realpath "$DEVKITXSH_DIR" 2>/dev/null || echo "$DEVKITXSH_DIR")"
DEVKITX_BRANCH="${DEVKITX_BRANCH:-main}"
DEVKITX_REPO_URL="${DEVKITX_REPO_URL:-https://github.com/ctrlmaniac/devkitx.git}"

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

require_sudo() {
	if sudo -v >/dev/null 2>&1; then
		log_success "Sudo privileges confirmed."
		return 0
	fi

	log_warn "Sudo privileges are required. Attempting to gain privileges..."

	if command -v sudo >/dev/null 2>&1 && sudo -v; then
		log_success "Sudo privileges granted."
		return 0
	fi

	log_error "Failed to obtain sudo privileges."
	log_error "Please run as a user with sudo rights and try again."
	exit 1
}

download_devkitxsh() {
	log_info "Preparing to download DevKitXsh into: $DEVKITXSH_DIR"

	if [[ -d "$DEVKITXSH_DIR" ]]; then
		log_warn "DevKitXsh already installed at $DEVKITXSH_DIR. Skipping clone."
		return 0
	fi

	log_info "Cloning DevKitXsh from $DEVKITX_REPO_URL (branch: $DEVKITX_BRANCH)..."

	mkdir -p "$DEVKITXSH_DIR"
	git init "$DEVKITXSH_DIR" >/dev/null 2>&1
	cd "$DEVKITXSH_DIR"

	git remote add origin "$DEVKITX_REPO_URL"
	git config core.sparseCheckout true
	printf "%s\n" "devkitxsh/*" >.git/info/sparse-checkout
	git pull origin "$DEVKITX_BRANCH"

	# Clean up .git to avoid accidental commits
	rm -rf .git

	log_success "DevKitXsh cloned successfully."
}

install_devkitxsh() {
	log_info "Starting DevKitXsh installation..."

	if [[ -f "$DEVKITXSH_DIR/install.sh" ]]; then
		bash "$DEVKITXSH_DIR/install.sh"
		log_success "DevKitXsh installed successfully."
	else
		log_error "Installation script not found in $DEVKITXSH_DIR."
		log_error "Aborting installation."
		exit 1
	fi
}

main() {
	print_banner
	require_sudo
	download_devkitxsh
	install_devkitxsh
}

main "$@"
