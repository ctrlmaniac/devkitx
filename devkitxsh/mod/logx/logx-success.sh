#!/usr/bin/env bash
# logx-success.sh - Funzione per messaggi di successo (logx)

set -euo pipefail

logx::success() {
	local msg="$*"

	[[ "${LOGX_QUIET:-false}" == "true" ]] && return 0

	local emoji="✅"
	if [[ "${LOGX_PLAIN:-false}" == "true" ]] || [[ "${DEVKITX_EMOJI:-true}" == "false" ]]; then
		emoji=""
	fi

	if [[ -n "$emoji" ]]; then
		printf "%b logx success: %s\n" "$emoji" "$msg"
	else
		printf "logx success: %s\n" "$msg"
	fi
}
