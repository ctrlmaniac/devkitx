#!/usr/bin/env bash
set -euo pipefail

# File: devkitx.sh
# Location: $DEVKITX_DIR/devkitx.sh
#
# Description:
#   Main loader script for the DevkitX modular toolkit.
#   It manages module loading, module installation, and global flags for output control.
#
#   This script serves as the central CLI entry point to interact with individual
#   modules located under the $DEVKITX_MOD_PATH directory, such as 'logx', 'deno', 'node', etc.
#
# Environment Variables:
#   DEVKITX_DIR        - Root directory where DevkitX is installed (default: "$HOME/.devkitx")
#   DEVKITX_MOD_PATH   - Directory where modules are installed (default: "$DEVKITX_DIR/mod")
#   DEVKITX_QUIET      - If "true", suppresses all non-error output (can be overridden by --quiet)
#   DEVKITX_PLAIN      - If "true", disables emoji output globally (can be overridden by --plain)
#
# Usage:
#   devkitx [--quiet|-q] [--plain] <command> [args...]
#   devkitx mod install <module>
#
# Examples:
#   devkitx --plain logx --success "Operation completed"
#   devkitx mod install logx
#

# Default installation and module directories
DEVKITX_DIR="${DEVKITX_DIR:-$HOME/.devkitx}"
DEVKITX_MOD_PATH="${DEVKITX_MOD_PATH:-$DEVKITX_DIR/mod}"

# Global flags, overridable via environment variables
QUIET=${DEVKITX_QUIET:-false}
PLAIN=${DEVKITX_PLAIN:-false}

# Ensure the module directory exists
mkdir -p "$DEVKITX_MOD_PATH"

# Function: log_info
# Purpose: Print informational messages unless quiet mode is enabled.
# Parameters:
#   $* - The message string.
log_info() {
	[[ "$QUIET" == true ]] && return
	if [[ "$PLAIN" == true ]]; then
		printf "%s\n" "$*"
	else
		printf "ℹ️  %s\n" "$*"
	fi
}

# Function: log_warn
# Purpose: Print warning messages unless quiet mode is enabled.
# Parameters:
#   $* - The warning message string.
log_warn() {
	[[ "$QUIET" == true ]] && return
	if [[ "$PLAIN" == true ]]; then
		printf "WARNING: %s\n" "$*"
	else
		printf "⚠️  WARNING: %s\n" "$*"
	fi
}

# Function: log_error
# Purpose: Print error messages to stderr regardless of quiet mode.
# Parameters:
#   $* - The error message string.
log_error() {
	if [[ "$PLAIN" == true ]]; then
		printf "ERROR: %s\n" "$*" >&2
	else
		printf "❌ ERROR: %s\n" "$*" >&2
	fi
}

# Function: load_module
# Purpose:
#   Loads the specified module script from the module path.
# Parameters:
#   $1 - Module name (e.g., 'logx').
# Behavior:
#   Sources the module script "$DEVKITX_MOD_PATH/<module>/<module>.sh" if exists,
#   otherwise prints an error and exits.
load_module() {
	local module=$1
	local mod_script="$DEVKITX_MOD_PATH/$module/$module.sh"

	if [[ -f "$mod_script" ]]; then
		# shellcheck source=/dev/null
		. "$mod_script"
	else
		log_error "Module '%s' not found. Please install it using:\n  devkitx mod install %s" "$module" "$module"
		exit 1
	fi
}

# Function: install_module
# Purpose:
#   Downloads and installs a module into the module path.
# Parameters:
#   $1 - Module name to install.
# Behavior:
#   Downloads core files for the module from the official remote repository.
install_module() {
	local module=$1
	local url_base="https://raw.githubusercontent.com/ctrlmaniac/devkitx/refs/heads/main/bin/mod"
	local target_dir="$DEVKITX_MOD_PATH/$module"

	if [[ -d "$target_dir" ]]; then
		log_warn "Module '%s' is already installed." "$module"
		return 0
	fi

	log_info "Installing module '%s'..." "$module"
	mkdir -p "$target_dir"

	# List of files expected for module installation
	local files=("$module.sh" "install.sh" "help/help.sh")

	for file in "${files[@]}"; do
		local url="$url_base/$module/$file"
		local dest="$target_dir/$file"
		if ! curl -fsSL "$url" -o "$dest"; then
			log_error "Failed to download '%s' for module '%s'" "$file" "$module"
			return 1
		fi
	done

	log_info "Module '%s' installed successfully at %s" "$module" "$target_dir"
}

# Function: parse_global_flags
# Purpose:
#   Parses and processes global flags --quiet/-q and --plain.
#   Sets the QUIET and PLAIN variables accordingly.
#   Removes parsed flags from the argument list.
parse_global_flags() {
	local i=0
	local args=("$@")
	local filtered_args=()

	while [[ $i -lt ${#args[@]} ]]; do
		case "${args[i]}" in
		--quiet | -q)
			QUIET=true
			;;
		--plain)
			PLAIN=true
			;;
		*)
			filtered_args+=("${args[i]}")
			;;
		esac
		((i++))
	done

	# Reset positional parameters with filtered arguments
	set -- "${filtered_args[@]}"
	echo "$@" # return filtered arguments via stdout
}

# Main entry point
main() {
	# Parse global flags first, then shift them out of arguments
	local parsed_args
	parsed_args=$(parse_global_flags "$@")
	# Read parsed_args back as array
	read -r -a args_array <<<"$parsed_args"

	if [[ ${#args_array[@]} -eq 0 ]]; then
		printf "devkitx - Modular toolkit\n"
		printf "Usage:\n"
		printf "  devkitx [--quiet|-q] [--plain] <command> [args...]\n"
		printf "  devkitx mod install <module>\n"
		exit 0
	fi

	local cmd="${args_array[0]}"
	# Shift the first element
	args_array=("${args_array[@]:1}")

	case "$cmd" in
	mod)
		if [[ ${#args_array[@]} -lt 2 ]]; then
			printf "Usage: devkitx mod install <module>\n"
			exit 1
		fi
		local subcmd="${args_array[0]}"
		local module="${args_array[1]}"
		args_array=("${args_array[@]:2}")

		case "$subcmd" in
		install) install_module "$module" ;;
		*)
			log_error "Unknown mod subcommand: %s" "$subcmd"
			exit 1
			;;
		esac
		;;

	*)
		load_module "$cmd"
		local func="${cmd}_main"
		if declare -f "$func" >/dev/null; then
			"$func" "${args_array[@]}"
		else
			log_error "Module '%s' does not implement main function." "$cmd"
			exit 1
		fi
		;;
	esac
}

# Execute main with all CLI arguments
main "$@"
