#!/usr/bin/env sh
# File: devkitxsh/mod/logx/logx-success.sh
# Location: $DEVKITX_REPO/devkitxsh/mod/logx/logx-success.sh
#
# Description:
#   Defines the 'logx::success' function for the DevKitXsh 'logx' module.
#   This function is responsible for displaying success messages.
#   It supports plain mode (no emoji) and respects global emoji settings.
#   Success messages are output to stdout.
#   This function can be suppressed if the LOGX_QUIET environment variable is set to "true".
#
# Usage:
#   This script is intended to be sourced by other scripts within the 'logx' module.
#   Example:
#     source "path/to/logx-success.sh"
#     logx::success "Operation completed successfully."
#
# Functions:
#   logx::success <message> - Displays a success message to stdout.
#
# Environment Variables:
#   LOGX_QUIET      If set to "true", the success message will be suppressed.
#   LOGX_PLAIN      If set to "true", emoji output will be disabled for this message.
#   DEVKITX_EMOJI   If set to "false", emoji output will be disabled globally (and for this message).

set -eu

logx_success() {
	msg="$*"

	[ "${LOGX_QUIET:-false}" = "true" ] && return 0

	emoji="✅"
	if [ "${LOGX_PLAIN:-false}" = "true" ] || [ "${DEVKITX_EMOJI:-true}" = "false" ]; then
		emoji=""
	fi

	if [ -n "$emoji" ]; then
		printf "%s logx success: %s\n" "$emoji" "$msg"
	else
		printf "logx success: %s\n" "$msg"
	fi
}
