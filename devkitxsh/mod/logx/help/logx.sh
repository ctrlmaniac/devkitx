#!/usr/bin/env sh
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
# This script assumes _LOGX_MODULE_DIR is set by the sourcing script (logx.sh)
# and points to the root of the logx module.
# shellcheck source=./logx-success.sh
. "$_LOGX_MODULE_DIR/help/logx-success.sh"
# shellcheck source=./logx-error.sh
. "$_LOGX_MODULE_DIR/help/logx-error.sh"
# shellcheck source=./logx-warn.sh
. "$_LOGX_MODULE_DIR/help/logx-warn.sh"
# shellcheck source=./logx-info.sh
. "$_LOGX_MODULE_DIR/help/logx-info.sh"

logx_help() {
	cmd="${1:-}"
	if [ -z "$cmd" ]; then
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
	success) logx_help_success ;;
	error) logx_help_error ;;
	warn) logx_help_warn ;;
	info) logx_help_info ;;
	help) printf "Help for 'logx help <subcommand>' is not implemented. Use 'logx help' for general help or 'logx help <command>' for specific command help.\n" ;;
	*)
		printf "Unknown command for help: %s\n" "$cmd" >&2
		return 1
		;;
	esac
}
