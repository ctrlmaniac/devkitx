#!/usr/bin/env bash
# File: devkitxsh/mod/logx/help/logx.sh
# Location: $DEVKITX_REPO/devkitxsh/mod/logx/help/logx.sh
#
# Description:
#   Defines the main 'logx::help' function for the DevKitXsh 'logx' module.
#   This script acts as a dispatcher for help information.
#   If called without arguments, it displays general usage for the 'logx' command.
#   If called with a subcommand (e.g., 'info', 'error'), it sources and calls the
#   corresponding specific help function (e.g., 'logx::help::info').
#   The specific help functions respect LOGX_QUIET, LOGX_PLAIN, and DEVKITX_EMOJI.
#
# Usage:
#   This script is not intended for direct execution. It is sourced by:
#   devkitxsh/mod/logx/logx.sh
#
#   And then invoked via:
#   logx::help [subcommand]
#
# Functions:
#   logx::help [subcommand] - Displays general help or specific subcommand help.
#
# Environment Variables (affect sourced specific help functions):
#   LOGX_QUIET      If "true", suppresses specific help output.
#   LOGX_PLAIN      If "true", disables emoji in specific help output.
#   DEVKITX_EMOJI   If "false", globally disables emoji in specific help output.

# Source specific help command files
source "$(dirname "${BASH_SOURCE[0]}")/logx-success.sh"
source "$(dirname "${BASH_SOURCE[0]}")/logx-error.sh"
source "$(dirname "${BASH_SOURCE[0]}")/logx-warn.sh"
source "$(dirname "${BASH_SOURCE[0]}")/logx-info.sh"

logx::help() {
	local cmd="${1:-}"
	if [[ -z "$cmd" ]]; then
		printf "\nUsage: logx <command> [options] <message>\n"
		printf "Commands:\n"
		printf "  success   Success messages\n"
		printf "  error     Error messages\n"
		printf "  warn      Warning messages\n"
		printf "  info      Informational messages\n"
		printf "  help      Show this help message\n\n"
		printf "Example:\n"
		printf "  logx success 'Operation completed'\n"
		return 0
	fi

	case "$cmd" in
	success) logx::help::success ;;
	error) logx::help::error ;;
	warn) logx::help::warn ;;
	info) logx::help::info ;;
	help) printf "Help for 'logx help <subcommand>' is not implemented. Use 'logx help' for general help or 'logx help <command>' for specific command help.\n" ;;
	*)
		printf "Unknown command for help: %s\n" "$cmd" >&2
		return 1
		;;
	esac
}
