#!/usr/bin/env bash
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

set -euo pipefail

# Source module components
source "$(dirname "${BASH_SOURCE[0]}")/logx-success.sh"
source "$(dirname "${BASH_SOURCE[0]}")/logx-error.sh"
source "$(dirname "${BASH_SOURCE[0]}")/logx-warn.sh"
source "$(dirname "${BASH_SOURCE[0]}")/logx-info.sh"
source "$(dirname "${BASH_SOURCE[0]}")/help/logx.sh"

print_usage() {
	logx::help
}

main() {
	if [[ $# -eq 0 ]]; then
		print_usage
		exit 1
	fi

	local cmd="$1"
	shift

	case "$cmd" in
	success) logx::success "$@" ;;
	error) logx::error "$@" ;;
	warn) logx::warn "$@" ;;
	info) logx::info "$@" ;;
	help) logx::help "${1:-}" ;;
	*)
		printf "Unknown command: %s\n" "$cmd" >&2
		print_usage
		exit 1
		;;
	esac
}

main "$@"
