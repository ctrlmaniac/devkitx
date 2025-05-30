#!/usr/bin/env bash
# logx.sh — main CLI entrypoint for logx

LOGX_DIR="${LOGX_DIR:-$HOME/.devkitx/mod/logx}"
LOGX_PLAIN=${LOGX_PLAIN:-false}
LOGX_QUIET=${LOGX_QUIET:-false}

# Source utils (if available)
[[ -f "$LOGX_DIR/utils.sh" ]] && . "$LOGX_DIR/utils.sh"

print_logx_help() {
	if [[ -f "$LOGX_DIR/help/help.sh" ]]; then
		. "$LOGX_DIR/help/help.sh"
		logx::help::main
	else
		echo "Help module missing"
	fi
}

main() {
	local cmd=""
	local args=()
	local exit_code=1
	local abort=false

	while [[ $# -gt 0 ]]; do
		case "$1" in
		--success | success | -ok)
			cmd="success"
			shift
			;;
		--warn | warn | -w)
			cmd="warn"
			shift
			;;
		--error | error | -e)
			cmd="error"
			shift
			;;
		-q | --quiet)
			LOGX_QUIET=true
			shift
			;;
		--plain)
			LOGX_PLAIN=true
			shift
			;;
		--abort)
			abort=true
			shift
			;;
		--exit-code)
			exit_code="${2:-1}"
			shift 2
			;;
		-h | --help | help)
			print_logx_help
			return 0
			;;
		*)
			args+=("$1")
			shift
			;;
		esac
	done

	# fallback if no command provided
	[[ -z "$cmd" ]] && print_logx_help && return 0

	# Dispatch to the right script
	local cmd_script="$LOGX_DIR/logx-${cmd}.sh"
	if [[ -f "$cmd_script" ]]; then
		. "$cmd_script"
		"logx::${cmd}" "${args[@]}"
	else
		echo "Unknown command: $cmd"
		print_logx_help
		return 1
	fi

	# Handle --abort if set
	$abort && exit "$exit_code"
}

main "$@"
