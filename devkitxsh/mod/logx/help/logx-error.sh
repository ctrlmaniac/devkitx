#!/usr/bin/env sh
# File: devkitxsh/mod/logx/help/logx-error.sh
# Location: $DEVKITX_REPO/devkitxsh/mod/logx/help/logx-error.sh
#
# Description:
#   Defines the help message function for the 'logx error' subcommand.
#   This script is sourced by the main 'logx help' dispatcher and provides
#   detailed usage information for the error logging command.
#   The output respects LOGX_QUIET, LOGX_PLAIN, and DEVKITX_EMOJI environment variables.
#
# Usage:
#   This script is not intended for direct execution. It is sourced by:
#   devkitxsh/mod/logx/help/logx.sh
#
# Functions:
#   logx::help::error - Displays the detailed help text for the 'logx error' command.
#
# Environment Variables:
#   LOGX_QUIET      If "true", suppresses the help output.
#   LOGX_PLAIN      If "true", disables emoji in the help output.
#   DEVKITX_EMOJI   If "false", globally disables emoji (and for this help output).

logx_help_error() {
	quiet="${LOGX_QUIET:-false}"
	plain="${LOGX_PLAIN:-false}"
	disable_emoji="$plain" # Flag to disable emoji output
	[ "${DEVKITX_EMOJI:-true}" = "false" ] && disable_emoji=true

	$quiet && return 0
	# icon_char="❌" # Unused
	bullet_char="•"
	heading_char="🛠️"
	heading_display="$heading_char"

	if $disable_emoji; then
		# icon_char="" # If icon_char were used in printf, it would be cleared here
		heading_display=""
	fi

	printf "\n  %s logx error — Error messages\n\n" "$heading_display"
	printf "USAGE:\n"
	printf "  logx error [options] <message>\n\n"
	printf "OPTIONS:\n"
	printf "  %s --plain         Disable emoji\n" "$bullet_char"
	printf "  %s --quiet, -q     Disable output\n" "$bullet_char"
	printf "  %s --abort         Exit after output\n" "$bullet_char"               # Note: This option is not in current logx::error
	printf "  %s --exit-code n   Specify exit code (default 1)\n\n" "$bullet_char" # Note: This option is not in current logx::error
	printf "EXAMPLES:\n"
	printf "  logx error 'Critical error detected'\n"
	printf "  logx error --plain 'Message without emoji'\n\n"
}
