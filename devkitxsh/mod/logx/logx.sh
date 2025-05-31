#!/usr/bin/env bash
# logx.sh - CLI principale per logx

set -euo pipefail

# Importa i moduli
source "$(dirname "${BASH_SOURCE[0]}")/logx-success.sh"
source "$(dirname "${BASH_SOURCE[0]}")/logx-error.sh"
source "$(dirname "${BASH_SOURCE[0]}")/logx-warn.sh"
source "$(dirname "${BASH_SOURCE[0]}")/logx-info.sh"
source "$(dirname "${BASH_SOURCE[0]}")/help/logx.sh"

print_usage() {
	logx::help
}

main() {
	if [[ $# -eq 0 ]]; then
		print_usage
		exit 1
	fi

	local cmd="$1"
	shift

	case "$cmd" in
	success) logx::success "$@" ;;
	error) logx::error "$@" ;;
	warn) logx::warn "$@" ;;
	info) logx::info "$@" ;;
	help) logx::help "${1:-}" ;;
	*)
		printf "Comando sconosciuto: %s\n" "$cmd"
		print_usage
		exit 1
		;;
	esac
}

main "$@"
