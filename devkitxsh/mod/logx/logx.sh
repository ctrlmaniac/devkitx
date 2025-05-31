#!/usr/bin/env sh
# File: devkitxsh/mod/logx/logx.sh
# Location: $DEVKITX_REPO/devkitxsh/mod/logx/logx.sh
#
# Description:
#   Main command-line interface (CLI) for the DevKitXsh 'logx' module.
#   This script acts as a dispatcher, sourcing and invoking specific 'logx::'
#   functions (e.g., logx::info, logx::error) based on the provided subcommand.
#   It also provides access to help information for the module.
#
# Usage:
#   bash path/to/logx.sh <command> [arguments...]
#
#   Examples:
#     bash devkitxsh/mod/logx/logx.sh info "This is an informational message."
#     bash devkitxsh/mod/logx/logx.sh error "An error occurred."
#     bash devkitxsh/mod/logx/logx.sh help info
#
# Commands:
#   success <message> - Displays a success message.
#   error <message>   - Displays an error message.
#   warn <message>    - Displays a warning message.
#   info <message>    - Displays an informational message.
#   help [command]    - Displays help information for the logx module or a specific command.
#
# Environment Variables (affect sourced functions):
#   LOGX_QUIET      If "true", suppresses info, success, and warn messages.
#   LOGX_PLAIN      If "true", disables emoji output in messages.
#   DEVKITX_EMOJI   If "false", globally disables emoji output in messages.

set -eu

# Determine the directory of the logx.sh script itself.
_LOGX_MODULE_DIR=$(cd "$(dirname -- "$0")" >/dev/null 2>&1 && pwd -P)
if [ -z "$_LOGX_MODULE_DIR" ]; then
	printf "Error: Could not determine module directory from '%s'\n" "$0" >&2
	exit 1
fi

# Source module components
# shellcheck source=./logx-success.sh
. "$_LOGX_MODULE_DIR/logx-success.sh"
# shellcheck source=./logx-error.sh
. "$_LOGX_MODULE_DIR/logx-error.sh"
# shellcheck source=./logx-warn.sh
. "$_LOGX_MODULE_DIR/logx-warn.sh"
# shellcheck source=./logx-info.sh
. "$_LOGX_MODULE_DIR/logx-info.sh"
# shellcheck source=./help/logx.sh
. "$_LOGX_MODULE_DIR/help/logx.sh"

print_usage() {
	logx_help
}

main() {
	if [ "$#" -eq 0 ]; then
		print_usage
		exit 1
	fi

	cmd="$1"
	shift

	case "$cmd" in
	success) logx_success "$@" ;;
	error) logx_error "$@" ;;
	warn) logx_warn "$@" ;;
	info) logx_info "$@" ;;
	help) logx_help "${1:-}" ;;
	*)
		printf "Unknown command: %s\n" "$cmd" >&2
		print_usage
		exit 1
		;;
	esac
}

main "$@"
