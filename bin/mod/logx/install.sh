#!/usr/bin/env bash
# install.sh - installer for logx module
#
# Usage:
#   ./install.sh [--plain] [--quiet|-q]

set -euo pipefail

# Environment variables
DEVKITX_DIR="${DEVKITX_DIR:-.devkitx}"
DEVKITX="${DEVKITX:-$HOME/$DEVKITX_DIR}"
DEVKITX_MOD_PATH="${DEVKITX_MOD_PATH:-mod}"

LOGX_DIR="$DEVKITX/$DEVKITX_MOD_PATH/logx"

LOGX_PLAIN=false
LOGX_QUIET=false

print_help() {
	cat <<EOF
Usage: install.sh [--plain] [--quiet|-q]

Options:
  --plain        Install logx without emoji support
  --quiet, -q    Suppress output messages
  --help, -h     Show this help message
EOF
}

# Parse args
while [[ $# -gt 0 ]]; do
	case "$1" in
	--plain) LOGX_PLAIN=true ;;
	--quiet | -q) LOGX_QUIET=true ;;
	--help | -h)
		print_help
		exit 0
		;;
	*)
		echo "Unknown option: $1" >&2
		print_help
		exit 1
		;;
	esac
	shift
done

_log() {
	local msg="$*"
	if [[ "$LOGX_QUIET" == "false" ]]; then
		if [[ "$LOGX_PLAIN" == "true" ]]; then
			echo "$msg"
		else
			echo "✅ $msg"
		fi
	fi
}

# Check or create directories
if [[ ! -d "$LOGX_DIR" ]]; then
	mkdir -p "$LOGX_DIR"
	_log "Created directory $LOGX_DIR"
fi

# Copy files from local repo (simulate download or clone here)
# In a real installer, you might curl or git clone from remote repo

# For demonstration, assume files are local relative to this script:
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy all logx files excluding install.sh itself
for file in "$SRC_DIR"/*; do
	basefile="$(basename "$file")"
	if [[ "$basefile" != "install.sh" ]]; then
		cp -r "$file" "$LOGX_DIR/"
	fi
done

_log "Installed logx module to $LOGX_DIR"

# Ensure devkitx loader files exist (simulate, can be expanded)
LOADER_DIR="$DEVKITX/$DEVKITX_MOD_PATH/_libs"
if [[ ! -d "$LOADER_DIR" ]]; then
	mkdir -p "$LOADER_DIR"
	_log "Created loader directory $LOADER_DIR"
fi

# Optionally: download or install core loader scripts if missing (not implemented here)

_log "logx installation complete."

exit 0
