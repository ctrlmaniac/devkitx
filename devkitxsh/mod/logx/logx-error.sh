#!/usr/bin/env bash
# logx-error.sh — Error message formatter for logx

set -euo pipefail

logx::error() {
	local msg="$*"

	# Exit early if quiet mode
	if [[ "${LOGX_QUIET:-false}" == "true" ]]; then
		return 0
	fi

	local emoji="❌"
	[[ "${LOGX_PLAIN:-false}" == "true" ]] || [[ "${DEVKITX_EMOJI:-true}" == "false" ]] && emoji=""

	if [[ -n "$emoji" ]]; then
		printf "%b logx error: %s\n" "$emoji" "$msg"
	else
		printf "logx error: %s\n" "$msg"
	fi
}

# Entry point for CLI usage
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	if [[ "$1" == "--help" || "$1" == "-h" || "$1" == "help" ]]; then
		. "${LOGX_HELP_DIR:-$(dirname "$0")/help}/logx-error.sh"
		logx::help::error
		exit 0
	fi

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
			. "${LOGX_HELP_DIR:-$(dirname "$0")/help}/logx-error.sh"
			logx::help::error
			exit 0
			;;
		*) break ;;
		esac
		shift
	done

	logx::error "$@"
	$ABORT && exit "$EXIT_CODE"
fi
