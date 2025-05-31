#!/usr/bin/env bash
# install.sh — Installer per il mod logx di DevKitXSH

set -euo pipefail

MOD_NAME="logx"
MOD_SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MOD_FILES=(
	logx.sh
	logx-error.sh
	logx-info.sh
	logx-success.sh
	logx-warn.sh
	help/logx.sh
	help/logx-error.sh
	help/logx-info.sh
	help/logx-success.sh
	help/logx-warn.sh
)

: "${DEVKITXSH_DIR:?❌ Variabile DEVKITXSH_DIR non definita}"
: "${DEVKITXSH_MOD_DIR:="${DEVKITXSH_DIR}/mods"}"
: "${DEVKITXSH_LIB_DIR:="${DEVKITXSH_DIR}/lib"}"

LOADER_URL="https://raw.githubusercontent.com/ctrlmaniac/devkitx/refs/heads/main/devkitxsh/lib/mod-loader.sh"
LOADER_FILE="${DEVKITXSH_LIB_DIR}/mod-loader.sh"

log() { printf "%s\n" "$@"; }
err() { printf "❌ %s\n" "$@" >&2; }
ok() { printf "✅ %s\n" "$@"; }
warn() { printf "⚠️  %s\n" "$@" >&2; }

main() {
	log "🔧 Installazione del mod '${MOD_NAME}'..."

	if [[ ! -f "$LOADER_FILE" ]]; then
		warn "mod-loader.sh non trovato. Lo installerò automaticamente..."
		mkdir -p "$DEVKITXSH_LIB_DIR"
		curl -fsSL "$LOADER_URL" -o "$LOADER_FILE" || {
			err "Impossibile scaricare il mod loader da: $LOADER_URL"
			exit 1
		}
		ok "mod-loader.sh installato in $LOADER_FILE"
	else
		ok "mod-loader.sh già presente"
	fi

	MOD_TARGET_DIR="$DEVKITXSH_MOD_DIR/${MOD_NAME}"
	mkdir -p "$MOD_TARGET_DIR/help"

	for file in "${MOD_FILES[@]}"; do
		src="$MOD_SOURCE_DIR/$file"
		dst="$MOD_TARGET_DIR/$file"

		if [[ ! -f "$src" ]]; then
			warn "File mancante: $src (ignorato)"
			continue
		fi

		mkdir -p "$(dirname "$dst")"
		cp "$src" "$dst"
		ok "File copiato: $file"
	done

	ok "Mod '${MOD_NAME}' installato con successo 🎉"
	echo ""
	log "ℹ️  Ora puoi caricare il mod con: mod_load ${MOD_NAME}"
}

main "$@"
