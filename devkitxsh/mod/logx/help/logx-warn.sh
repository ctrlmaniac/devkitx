#!/usr/bin/env bash
# help/logx-error.sh - Help per comando error di logx

logx::help::error() {
	local quiet="${LOGX_QUIET:-false}"
	local plain="${LOGX_PLAIN:-false}"
	local emoji="$plain"
	[[ "${DEVKITX_EMOJI:-true}" == "false" ]] && emoji=true

	$quiet && return 0

	local icon="❌"
	local bullet="•"
	local heading="🛠️"

	$emoji && icon=""

	printf "\n  %s logx error — Messaggi di errore\n\n" "$heading"
	printf "USO:\n"
	printf "  logx error [options] <messaggio>\n\n"
	printf "OPZIONI:\n"
	printf "  %s --plain         Disabilita emoji\n" "$bullet"
	printf "  %s --quiet, -q     Disabilita output\n" "$bullet"
	printf "  %s --abort         Esci dopo output\n" "$bullet"
	printf "  %s --exit-code n   Specifica codice uscita (default 1)\n\n" "$bullet"
	printf "ESEMPI:\n"
	printf "  logx error 'Errore critico rilevato'\n"
	printf "  logx error --plain 'Messaggio senza emoji'\n\n"
}
