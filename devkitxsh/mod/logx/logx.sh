#!/usr/bin/env bash
set -euo pipefail

# File: devkitxsh/mod/logx/logx.sh
# Description:
#   Modulo di logging per DevKitXsh con supporto a livelli di log, output silenziato e disabilitazione colori/emoji.
#
# Usage:
#   source logx.sh
#
# Variables:
#   LOGX_QUIET  - se impostata a 1 disabilita output informativo
#   LOGX_PLAIN  - se impostata a 1 disabilita colori ed emoji
#
# Functions:
#   logx_info "Messaggio"
#   logx_success "Messaggio"
#   logx_warn "Messaggio"
#   logx_error "Messaggio"

# Codici colore ANSI
readonly LOGX_COLOR_RED='\033[0;31m'
readonly LOGX_COLOR_GREEN='\033[0;32m'
readonly LOGX_COLOR_YELLOW='\033[1;33m'
readonly LOGX_COLOR_ORANGE='\033[0;33m'
readonly LOGX_COLOR_RESET='\033[0m'

# Emoji (disabilitabili con --plain)
readonly LOGX_EMOJI_INFO="ℹ️ "
readonly LOGX_EMOJI_SUCCESS="✅ "
readonly LOGX_EMOJI_WARN="⚠️ "
readonly LOGX_EMOJI_ERROR="❌ "

# Funzione interna per gestire output log con colori e emoji
_logx_print() {
	local level="$1"
	local color="$2"
	local emoji="$3"
	local message="$4"

	# Se quiet, esci senza stampare
	[[ "${LOGX_QUIET:-0}" == "1" ]] && return 0

	# Se plain, rimuovi emoji e colori
	if [[ "${LOGX_PLAIN:-0}" == "1" ]]; then
		printf '%s %s\n' "[$level]" "$message"
	else
		# Usare printf con placeholder per sicurezza SC2059
		printf '%b %b%s%b\n' "$emoji" "$color" "[$level] $message" "$LOGX_COLOR_RESET"
	fi
}

logx_info() {
	_logx_print "INFO" "$LOGX_COLOR_YELLOW" "$LOGX_EMOJI_INFO" "$*"
}

logx_success() {
	_logx_print "OK" "$LOGX_COLOR_GREEN" "$LOGX_EMOJI_SUCCESS" "$*"
}

logx_warn() {
	_logx_print "WARN" "$LOGX_COLOR_ORANGE" "$LOGX_EMOJI_WARN" "$*"
}

logx_error() {
	_logx_print "ERR" "$LOGX_COLOR_RED" "$LOGX_EMOJI_ERROR" "$*" >&2
}
