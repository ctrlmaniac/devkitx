#!/usr/bin/env bash
# help/logx.sh - Dispatcher help per logx

logx::help() {
	local cmd="${1:-}"
	if [[ -z "$cmd" ]]; then
		printf "\nUso: logx <comando> [opzioni] <messaggio>\n"
		printf "Comandi:\n"
		printf "  success   Messaggi di successo\n"
		printf "  error     Messaggi di errore\n"
		printf "  warn      Messaggi di avviso\n"
		printf "  info      Messaggi informativi\n"
		printf "  help      Mostra questo aiuto\n\n"
		printf "Esempio:\n"
		printf "  logx success 'Operazione completata'\n"
		return 0
	fi

	case "$cmd" in
	success) logx::help::success ;;
	error) logx::help::error ;;
	warn) logx::help::warn ;;
	info) logx::help::info ;;
	help) printf "logx help non implementato per sottocomando\n" ;;
	*)
		printf "Comando sconosciuto: %s\n" "$cmd"
		return 1
		;;
	esac
}
