#!/usr/bin/env bash
# File: devkitxsh/mod/logx/logx-error.sh
# Location: $DEVKITX_REPO/devkitxsh/mod/logx/logx-error.sh
#
# Description:
#   Defines the 'logx::error' function for the DevKitXsh 'logx' module.
#   This function is responsible for displaying error messages.
#   It supports plain mode (no emoji) and respects global emoji settings.
#   Error messages are output to stderr.
#   Note: Unlike typical error handlers, this function can be suppressed if
#   the LOGX_QUIET environment variable is set to "true".
#
# Usage:
#   This script is intended to be sourced by other scripts within the 'logx' module.
#   Example:
#     source "path/to/logx-error.sh"
#     logx::error "A critical error occurred."
#
# Functions:
#   logx::error <message> - Displays an error message to stderr.
#
# Environment Variables:
#   LOGX_QUIET      If set to "true", the error message will be suppressed.
#   LOGX_PLAIN      If set to "true", emoji output will be disabled for this message.
#   DEVKITX_EMOJI   If set to "false", emoji output will be disabled globally (and for this message).

set -euo pipefail

logx::error() {
	local msg="$*"

	[[ "${LOGX_QUIET:-false}" == "true" ]] && return 0

	local emoji="❌"
	if [[ "${LOGX_PLAIN:-false}" == "true" ]] || [[ "${DEVKITX_EMOJI:-true}" == "false" ]]; then
		emoji=""
	fi

	if [[ -n "$emoji" ]]; then
		printf "%b logx error: %s\n" "$emoji" "$msg" >&2
	else
		printf "logx error: %s\n" "$msg" >&2
	fi
}
