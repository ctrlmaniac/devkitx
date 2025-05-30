#!/usr/bin/env bash
set -euo pipefail

# File: mod/logx/install.sh
# Location: $DEVKITX_DIR/mod/logx/install.sh
#
# Description:
#   Installer script for the logx module within the DevkitX toolkit.
#   Downloads and installs the logx module files into the DevkitX module path.
#
# Usage:
#   ./install.sh [--quiet|-q] [--plain]
#
# Flags:
#   --quiet, -q   Suppress informational output (errors still shown)
#   --plain      Disable emoji output in messages
#
# Environment variables:
#   DEVKITX_DIR         Base directory of DevkitX installation (default: $HOME/.devkitx)
#   DEVKITX_MOD_PATH    Path where modules are installed (default: $DEVKITX_DIR/mod)

DEVKITX_DIR="${DEVKITX_DIR:-$HOME/.devkitx}"
DEVKITX_MOD_PATH="${DEVKITX_MOD_PATH:-$DEVKITX_DIR/mod}"
MODULE_NAME="logx"
MODULE_DIR="$DEVKITX_MOD_PATH/$MODULE_NAME"
REPO_BASE_URL="https://raw.githubusercontent.com/ctrlmaniac/devkitx/refs/heads/main/bin/mod/$MODULE_NAME"

QUIET=false
PLAIN=false

# Parse CLI flags
while (("$#")); do
	case "$1" in
	--quiet | -q)
		QUIET=true
		shift
		;;
	--plain)
		PLAIN=true
		shift
		;;
	*)
		printf "Unknown option: %s\n" "$1" >&2
		exit 1
		;;
	esac
done

# Print informational messages unless quiet
log_info() {
	$QUIET && return
	if $PLAIN; then
		printf "%s\n" "$*"
	else
		printf "ℹ️  %s\n" "$*"
	fi
}

# Print warnings unless quiet
log_warn() {
	$QUIET && return
	if $PLAIN; then
		printf "WARNING: %s\n" "$*"
	else
		printf "⚠️  WARNING: %s\n" "$*"
	fi
}

# Print errors always to stderr
log_error() {
	if $PLAIN; then
		printf "ERROR: %s\n" "$*" >&2
	else
		printf "❌ ERROR: %s\n" "$*" >&2
	fi
}

# Download a file from repository, saving to target path
# Arguments:
#   $1 - Relative file path in repo (e.g. "logx.sh")
#   $2 - Destination absolute path
download_file() {
	local file_path=$1
	local dest_path=$2

	if ! curl -fsSL "$REPO_BASE_URL/$file_path" -o "$dest_path"; then
		log_error "Failed to download %s" "$file_path"
		exit 1
	fi
}

main() {
	if [[ -d "$MODULE_DIR" ]]; then
		log_warn "Module '$MODULE_NAME' is already installed at $MODULE_DIR"
		exit 0
	fi

	log_info "Installing module '$MODULE_NAME' to $MODULE_DIR..."
	mkdir -p "$MODULE_DIR"

	# Files required for the module installation
	local files=(
		"$MODULE_NAME.sh"
		"install.sh"
		"help/help.sh"
		"help/logx-error.sh"
		"help/logx-success.sh"
		"help/logx-warn.sh"
	)

	for file in "${files[@]}"; do
		local dest="$MODULE_DIR/$file"
		mkdir -p "$(dirname "$dest")"
		download_file "$file" "$dest"
	done

	log_info "Module '$MODULE_NAME' installed successfully."
}

main
