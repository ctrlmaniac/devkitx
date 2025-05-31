#!/usr/bin/env bash
# logx-warn.sh - Funzione per messaggi di avviso (logx)

set -euo pipefail

logx::warn() {
	local msg="$*"

	[[ "${LOGX_QUIET:-false}" == "true" ]] && return 0

	local emoji="⚠️"
	if [[ "${LOGX_PLAIN:-false}" == "true" ]] || [[ "${DEVKITX_EMOJI:-true}" == "false" ]]; then
		emoji=""
	fi

	if [[ -n "$emoji" ]]; then
		printf "%b logx warn: %s\n" "$emoji" "$msg"
	else
		printf "logx warn: %s\n" "$msg"
	fi
}
