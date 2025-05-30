#!/usr/bin/env bash
# File: lib/mod-loader.sh
# Location: $DEVKITXSH_DIR/lib/mod-loader.sh
#
# Description:
#   Core mod loading system for DevKitXSH.
#   Provides the `mod_load` function to dynamically load shell mods from $DEVKITXSH_MOD_DIR.
#   Prevents double-loading and logs mod status to the console.
#
# Usage:
#   mod_load <mod-name>
#
# Example:
#   mod_load logx
#
# Environment Variables:
#   DEVKITXSH_MOD_DIR    Path to the directory containing DevKitXSH mods
#   DEVKITXSH_CONFIG_DIR Path to the config directory (used to resolve installed mods)

# Ensure required variables are available
: "${DEVKITXSH_MOD_DIR:?Missing DEVKITXSH_MOD_DIR}"
: "${DEVKITXSH_CONFIG_DIR:?Missing DEVKITXSH_CONFIG_DIR}"

_loaded_mods=()

mod_load() {
	local mod_name="$1"
	local mod_file="$DEVKITXSH_MOD_DIR/${mod_name}.sh"

	if [[ " ${_loaded_mods[*]} " == *" $mod_name "* ]]; then
		log_info "Module '$mod_name' already loaded. Skipping."
		return
	fi

	if [[ -f "$mod_file" ]]; then
		# shellcheck source=/dev/null
		source "$mod_file"
		_loaded_mods+=("$mod_name")
		log_success "Module '$mod_name' loaded"
	else
		log_error "Module '$mod_name' not found at $mod_file"
		return 1
	fi
}

mod_list_loaded() {
	printf '%s\n' "${_loaded_mods[@]}"
}
