#!/usr/bin/env bash
# utils.sh - utility functions for logx
# Provides functions for emoji support, quiet mode, and logging output

LOGX_PLAIN=${LOGX_PLAIN:-false}
LOGX_QUIET=${LOGX_QUIET:-false}

# Emoji constants
LOGX_EMOJI_SUCCESS="✅"
LOGX_EMOJI_WARN="⚠️"
LOGX_EMOJI_ERROR="❌"

# Internal function: print message with optional emoji unless quiet/plain mode
_logx_print() {
	local emoji="$1"
	shift
	local msg="$*"

	if [[ "$LOGX_QUIET" == "true" ]]; then
		return 0
	fi

	if [[ "$LOGX_PLAIN" == "true" ]]; then
		echo "$msg"
	else
		echo -e "${emoji} $msg"
	fi
}

# Public function: print success message
logx_print_success() {
	_logx_print "$LOGX_EMOJI_SUCCESS" "$@"
}

# Public function: print warning message
logx_print_warn() {
	_logx_print "$LOGX_EMOJI_WARN" "$@"
}

# Public function: print error message
logx_print_error() {
	_logx_print "$LOGX_EMOJI_ERROR" "$@"
}
