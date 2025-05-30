#!/usr/bin/env bash
set -euo pipefail

# DevKitXSH Installer Script
#
# This script bootstraps the DevKitXSH environment by:
#   1. Creating necessary config directories and files under ~/.config/devkitxsh
#   2. Exporting environment variables to shell profiles (~/.bashrc or ~/.zshrc)
#   3. Installing the CLI executable as `devkitx`
#   4. Registering the default `logx` module
#   5. Sourcing the module loader and configs for immediate use
#
# Author: ctrlmaniac
# License: MIT

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

log_info() { printf "${YELLOW}[INFO]${NC} %s\n" "$*"; }
log_success() { printf "${GREEN}[OK]${NC} %s\n" "$*"; }
log_warn() { printf "${ORANGE}[WARN]${NC} %s\n" "$*"; }
log_error() { printf "${RED}[ERR]${NC} %s\n" "$*" >&2; }

# Path definitions
export DEVKITXSH_DIR="${DEVKITXSH_DIR:-$HOME/.devkitxsh}"
export DEVKITXSH_MOD_DIR="${DEVKITXSH_MOD_DIR:-$DEVKITXSH_DIR/mod}"
export DEVKITXSH_CONFIG_DIR="${DEVKITXSH_CONFIG_DIR:-$HOME/.config/devkitxsh}"
export DEVKITXSH_CONFIG_FILE="${DEVKITXSH_CONFIG_FILE:-$DEVKITXSH_CONFIG_DIR/config.sh}"

SHELL_RC_FILE=""

detect_shell_rc() {
	if [[ "${SHELL:-}" == */zsh ]]; then
		SHELL_RC_FILE="$HOME/.zshrc"
	else
		SHELL_RC_FILE="$HOME/.bashrc"
	fi
}

# Create config files
bootstrap_config() {
	mkdir -p "$DEVKITXSH_CONFIG_DIR"
	touch "$DEVKITXSH_CONFIG_DIR/installed_mod.sh"
	cat >"$DEVKITXSH_CONFIG_FILE" <<EOF
# DevKitXSH config
export DEVKITXSH_DIR="$DEVKITXSH_DIR"
export DEVKITXSH_MOD_DIR="$DEVKITXSH_MOD_DIR"
export DEVKITXSH_CONFIG_DIR="$DEVKITXSH_CONFIG_DIR"
export DEVKITXSH_CONFIG_FILE="$DEVKITXSH_CONFIG_FILE"

# Load installed modules
source "\$DEVKITXSH_CONFIG_DIR/installed_mod.sh"
EOF

	log_success "Config initialized at $DEVKITXSH_CONFIG_FILE"
}

# Source loader function
load_module_loader() {
	local loader_file="$DEVKITXSH_DIR/lib/module-loader.sh"
	if [[ -f "$loader_file" ]]; then
		# shellcheck source=/dev/null
		source "$loader_file"
		log_success "Module loader sourced"
	else
		log_error "Module loader not found at $loader_file"
		exit 1
	fi
}

# Shell integration
setup_shell_exports() {
	detect_shell_rc

	if grep -q "DEVKITXSH_DIR=" "$SHELL_RC_FILE"; then
		log_info "Shell already configured. Skipping shell export."
		return
	fi

	cat >>"$SHELL_RC_FILE" <<EOF

# >>> DevKitXSH environment >>>
export DEVKITXSH_DIR="$DEVKITXSH_DIR"
export DEVKITXSH_MOD_DIR="$DEVKITXSH_MOD_DIR"
export DEVKITXSH_CONFIG_DIR="$DEVKITXSH_CONFIG_DIR"
export DEVKITXSH_CONFIG_FILE="$DEVKITXSH_CONFIG_FILE"
[[ -f "\$DEVKITXSH_CONFIG_FILE" ]] && source "\$DEVKITXSH_CONFIG_FILE"
# <<< DevKitXSH environment <<<
EOF

	log_success "Shell exports added to $SHELL_RC_FILE"

	# Apply changes to current session
	# shellcheck disable=SC1090
	source "$SHELL_RC_FILE"
}

# Install CLI launcher
install_executable() {
	local bin_path="$HOME/.local/bin"
	local target="$bin_path/devkitx"

	mkdir -p "$bin_path"
	cp "$DEVKITXSH_DIR/bin/devkitx.sh" "$target"
	chmod +x "$target"

	if ! grep -q "$bin_path" <<<"$PATH"; then
		log_warn "$bin_path is not in PATH. Adding to shell profile."
		printf "export PATH=\"%s:\$PATH\"\n" "$bin_path" >>"$SHELL_RC_FILE"

		# shellcheck disable=SC1090
		source "$SHELL_RC_FILE"
	fi

	log_success "Executable installed as: devkitx"
}

# 📦 Install logx module
install_logx_module() {
	if ! grep -q "mod_load logx" "$DEVKITXSH_CONFIG_DIR/installed_mod.sh"; then
		printf 'mod_load logx\n' >>"$DEVKITXSH_CONFIG_DIR/installed_mod.sh"
		log_success "logx module registered"
	else
		log_info "logx already present in installed mods"
	fi
}

# Main
main() {
	log_info "Starting DevKitXSH installer..."

	bootstrap_config
	load_module_loader
	setup_shell_exports
	install_executable
	install_logx_module

	log_success "DevKitXSH installation complete 🎉"
	printf "\nRun \`devkitx --help\` to get started.\n"
}

main "$@"
