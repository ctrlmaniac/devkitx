#!/usr/bin/env bash
# logx-info.sh - Funzione per messaggi informativi (logx)

set -euo pipefail

logx::info() {
	local msg="$*"

	[[ "${LOGX_QUIET:-false}" == "true" ]] && return 0

	local emoji="ℹ️"
	if [[ "${LOGX_PLAIN:-false}" == "true" ]] || [[ "${DEVKITX_EMOJI:-true}" == "false" ]]; then
		emoji=""
	fi

	if [[ -n "$emoji" ]]; then
		printf "%b logx info: %s\n" "$emoji" "$msg"
	else
		printf "logx info: %s\n" "$msg"
	fi
}
