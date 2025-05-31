#!/usr/bin/env bash
# help/logx-info.sh - Help per comando info di logx

logx::help::info() {
	local quiet="${LOGX_QUIET:-false}"
	local plain="${LOGX_PLAIN:-false}"
	local emoji="$plain"
	[[ "${DEVKITX_EMOJI:-true}" == "false" ]] && emoji=true

	$quiet && return 0

	local icon="ℹ️"
	local bullet="•"
	local heading="🛠️"

	$emoji && icon=""

	printf "\n  %s logx info — Messaggi informativi\n\n" "$heading"
	printf "USO:\n"
	printf "  logx info [options] <messaggio>\n\n"
	printf "OPZIONI:\n"
	printf "  %s --plain         Disabilita emoji\n" "$bullet"
	printf "  %s --quiet, -q     Disabilita output\n" "$bullet"
	printf "  %s --abort         Esci dopo output\n" "$bullet"
	printf "  %s --exit-code n   Specifica codice uscita (default 1)\n\n" "$bullet"
	printf "ESEMPI:\n"
	printf "  logx info 'Messaggio informativo'\n"
	printf "  logx info --plain 'Messaggio senza emoji'\n\n"
}
