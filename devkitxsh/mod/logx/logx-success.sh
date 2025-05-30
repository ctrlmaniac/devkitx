#!/usr/bin/env bash
# logx-success.sh - Success message formatter for logx

set -euo pipefail

logx::success() {
	local msg="$*"

	# Exit early if quiet mode
	if [[ "${LOGX_QUIET:-false}" == "true" ]]; then
		return 0
	fi

	# Emoji setup
	local emoji="✅"
	[[ "${LOGX_PLAIN:-false}" == "true" ]] || [[ "${DEVKITX_EMOJI:-true}" == "false" ]] && emoji=""

	if [[ -n "$emoji" ]]; then
		printf "%b logx success: %s\n" "$emoji" "$msg"
	else
		printf "logx success: %s\n" "$msg"
	fi
}

# Entry point for direct use (optional)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	if [[ "$1" == "--help" || "$1" == "-h" || "$1" == "help" ]]; then
		. "${LOGX_HELP_DIR:-$(dirname "$0")/help}/logx-success.sh"
		logx::help::success
		exit 0
	fi

	# CLI support
	LOGX_QUIET="${LOGX_QUIET:-false}"
	LOGX_PLAIN="${LOGX_PLAIN:-false}"
	ABORT=false
	EXIT_CODE=1

	while [[ $# -gt 0 ]]; do
		case "$1" in
		--plain) LOGX_PLAIN=true ;;
		--quiet | -q) LOGX_QUIET=true ;;
		--abort) ABORT=true ;;
		--exit-code)
			shift
			EXIT_CODE="${1:-1}"
			;;
		-h | --help | help)
			. "${LOGX_HELP_DIR:-$(dirname "$0")/help}/logx-success.sh"
			logx::help::success
			exit 0
			;;
		*) break ;;
		esac
		shift
	done

	logx::success "$@"
	$ABORT && exit "$EXIT_CODE"
fi
