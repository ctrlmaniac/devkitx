#!/usr/bin/env sh
# File: devkitxsh/mod/logx/install.sh
# Location: $DEVKITX_REPO/devkitxsh/mod/logx/install.sh
#
# Description:
#   Installer script for the 'logx' module of DevKitXsh.
#   This script copies the 'logx' module files into the appropriate
#   DevKitXsh modules directory. It also ensures that the 'mod-loader.sh'
#   utility is present in the DevKitXsh library directory, downloading it if necessary.
#
# Usage:
#   bash devkitxsh/mod/logx/install.sh
#
# Environment Variables:
#   DEVKITXSH_DIR       (Required) Path to the main DevKitXsh installation directory.
#   DEVKITXSH_MOD_DIR   Path to the DevKitXsh modules directory (default: $DEVKITXSH_DIR/mods).
#   DEVKITXSH_LIB_DIR   Path to the DevKitXsh library directory (default: $DEVKITXSH_DIR/lib).

set -eu

MOD_NAME="logx"
MOD_SOURCE_DIR=$(cd "$(dirname -- "$0")" && pwd -P)
MOD_FILES_STR="
	logx.sh
	logx-error.sh
	logx-info.sh
	logx-success.sh
	logx-warn.sh
	help/logx.sh
	help/logx-error.sh
	help/logx-info.sh
	help/logx-success.sh
	help/logx-warn.sh
"

: "${DEVKITXSH_DIR:?❌ DEVKITXSH_DIR variable not set}"
: "${DEVKITXSH_MOD_DIR:="${DEVKITXSH_DIR}/mods"}"
: "${DEVKITXSH_LIB_DIR:="${DEVKITXSH_DIR}/lib"}"

LOADER_URL="https://raw.githubusercontent.com/ctrlmaniac/devkitx/refs/heads/main/devkitxsh/lib/mod-loader.sh"
LOADER_FILE="${DEVKITXSH_LIB_DIR}/mod-loader.sh"

log_msg() { printf "%s\n" "$@"; }          # Renamed to avoid conflict if sourcing a global logger
err_msg() { printf "❌ %s\n" "$@" >&2; }    # Renamed
ok_msg() { printf "✅ %s\n" "$@"; }         # Renamed
warn_msg() { printf "⚠️  %s\n" "$@" >&2; } # Renamed

main() {
	log_msg "🔧 Installing module '${MOD_NAME}'..."

	if [ ! -f "$LOADER_FILE" ]; then
		warn_msg "mod-loader.sh not found. Will install it automatically..."
		mkdir -p "$DEVKITXSH_LIB_DIR"
		curl -fsSL "$LOADER_URL" -o "$LOADER_FILE" || {
			err_msg "Failed to download mod loader from: $LOADER_URL"
			exit 1
		}
		ok_msg "mod-loader.sh installed in $LOADER_FILE"
	else
		ok_msg "mod-loader.sh already present"
	fi

	MOD_TARGET_DIR="$DEVKITXSH_MOD_DIR/${MOD_NAME}"
	mkdir -p "$MOD_TARGET_DIR/help"

	for file in $MOD_FILES_STR; do
		src="$MOD_SOURCE_DIR/$file"
		dst="$MOD_TARGET_DIR/$file"

		if [ ! -f "$src" ]; then
			warn_msg "Missing file: $src (skipped)"
			continue
		fi

		mkdir -p "$(dirname "$dst")"
		cp "$src" "$dst"
		ok_msg "File copied: $file"
	done

	ok_msg "Module '${MOD_NAME}' installed successfully 🎉"
	printf "\n"
	log_msg "ℹ️  You can now load the module with: mod_load ${MOD_NAME}"
}

main "$@"
