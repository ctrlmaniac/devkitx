#!/usr/bin/env sh
# File: devkitxsh/mod/logx/logx-info.sh
# Location: $DEVKITX_REPO/devkitxsh/mod/logx/logx-info.sh
#
# Description:
#   Defines the 'logx::info' function for the DevKitXsh 'logx' module.
#   This function is responsible for displaying informational messages.
#   It supports plain mode (no emoji) and respects global emoji settings.
#   Informational messages are output to stdout.
#   This function can be suppressed if the LOGX_QUIET environment variable is set to "true".
#
# Usage:
#   This script is intended to be sourced by other scripts within the 'logx' module.
#   Example:
#     source "path/to/logx-info.sh"
#     logx::info "This is an informational update."
#
# Functions:
#   logx::info <message> - Displays an informational message to stdout.
#
# Environment Variables:
#   LOGX_QUIET      If set to "true", the informational message will be suppressed.
#   LOGX_PLAIN      If set to "true", emoji output will be disabled for this message.
#   DEVKITX_EMOJI   If set to "false", emoji output will be disabled globally (and for this message).

set -eu

logx_info() {
	msg="$*"

	[ "${LOGX_QUIET:-false}" = "true" ] && return 0

	emoji="ℹ️"
	if [ "${LOGX_PLAIN:-false}" = "true" ] || [ "${DEVKITX_EMOJI:-true}" = "false" ]; then
		emoji=""
	fi

	if [ -n "$emoji" ]; then
		printf "%s logx info: %s\n" "$emoji" "$msg"
	else
		printf "logx info: %s\n" "$msg"
	fi
}
