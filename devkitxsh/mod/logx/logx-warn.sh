#!/usr/bin/env sh
# File: devkitxsh/mod/logx/logx-warn.sh
# Location: $DEVKITX_REPO/devkitxsh/mod/logx/logx-warn.sh
#
# Description:
#   Defines the 'logx::warn' function for the DevKitXsh 'logx' module.
#   This function is responsible for displaying warning messages.
#   It supports plain mode (no emoji) and respects global emoji settings.
#   Warning messages are output to stderr.
#   This function can be suppressed if the LOGX_QUIET environment variable is set to "true".
#
# Usage:
#   This script is intended to be sourced by other scripts within the 'logx' module.
#   Example:
#     source "path/to/logx-warn.sh"
#     logx::warn "This is a warning message about a potential issue."
#
# Functions:
#   logx::warn <message> - Displays a warning message to stderr.
#
# Environment Variables:
#   LOGX_QUIET      If set to "true", the warning message will be suppressed.
#   LOGX_PLAIN      If set to "true", emoji output will be disabled for this message.
#   DEVKITX_EMOJI   If set to "false", emoji output will be disabled globally (and for this message).

set -eu

logx_warn() {
	msg="$*"

	[ "${LOGX_QUIET:-false}" = "true" ] && return 0

	emoji="⚠️"
	if [ "${LOGX_PLAIN:-false}" = "true" ] || [ "${DEVKITX_EMOJI:-true}" = "false" ]; then
		emoji=""
	fi

	if [ -n "$emoji" ]; then
		printf "%s logx warn: %s\n" "$emoji" "$msg" >&2
	else
		printf "logx warn: %s\n" "$msg" >&2
	fi
}
