#!/usr/bin/env bash
set -euo pipefail

# File: devkitxsh/utils/logger.sh
# Location: $DEVKITX_REPO/devkitxsh/utils/logger.sh
#
# Description:
#   Logging utilities for DevKitXsh CLI scripts.
#   Provides color-coded log functions with optional plain and quiet modes.
#
# Usage:
#   source devkitxsh/utils/logger.sh
#   logger_init "$@"  # Parses --quiet and --plain flags
#
# Flags (passed to logger_init):
#   --quiet, -q   Suppress info/success/warn output (errors still shown)
#   --plain       Disable color and emoji formatting
#
# Environment Variables (none)

# Internal color variables
LOG_COLOR_RED=""
LOG_COLOR_GREEN=""
LOG_COLOR_YELLOW=""
LOG_COLOR_ORANGE=""
LOG_COLOR_RESET=""

# Internal emoji (optional visual indicators)
EMOJI_INFO=""
EMOJI_SUCCESS=""
EMOJI_WARN=""
EMOJI_ERROR=""

# Logger state flags
LOGGER_QUIET=false
LOGGER_PLAIN=false

logger_init() {
	for arg in "$@"; do
		case "$arg" in
		--quiet | -q)
			LOGGER_QUIET=true
			;;
		--plain)
			LOGGER_PLAIN=true
			;;
		esac
	done

	if ! $LOGGER_PLAIN; then
		LOG_COLOR_RED='\033[0;31m'
		LOG_COLOR_GREEN='\033[0;32m'
		LOG_COLOR_YELLOW='\033[1;33m'
		LOG_COLOR_ORANGE='\033[0;33m'
		LOG_COLOR_RESET='\033[0m'

		EMOJI_INFO="ℹ️ "
		EMOJI_SUCCESS="✅"
		EMOJI_WARN="⚠️ "
		EMOJI_ERROR="❌"
	fi
}

log_info() {
	$LOGGER_QUIET && return
	printf "%s%s %s%s\n" "$LOG_COLOR_YELLOW" "$EMOJI_INFO" "$*" "$LOG_COLOR_RESET"
}

log_success() {
	$LOGGER_QUIET && return
	printf "%s%s %s%s\n" "$LOG_COLOR_GREEN" "$EMOJI_SUCCESS" "$*" "$LOG_COLOR_RESET"
}

log_warn() {
	$LOGGER_QUIET && return
	printf "%s%s %s%s\n" "$LOG_COLOR_ORANGE" "$EMOJI_WARN" "$*" "$LOG_COLOR_RESET"
}

log_error() {
	printf "%s%s %s%s\n" "$LOG_COLOR_RED" "$EMOJI_ERROR" "$*" "$LOG_COLOR_RESET" >&2
}
