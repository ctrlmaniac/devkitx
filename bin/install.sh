#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${YELLOW}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*"; }
log_error() { echo -e "${RED}[ERR]${NC} $*" >&2; }

# Paths
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLI_SH_DISPATCH="${ROOT_DIR}/bin/cli-sh/dispatch.sh"
# CLI_TS_DIR="${ROOT_DIR}/apps/devkitx"

# 1. Prerequisiti: controlla bash, curl, git, etc
function check_prerequisites() {
	log_info "Checking prerequisites..."

	for cmd in bash curl git; do
		if ! command -v "$cmd" &>/dev/null; then
			log_error "Required command '$cmd' is missing. Please install it and retry."
			exit 1
		fi
	done

	log_success "All prerequisites are met."
}

# 2. Installa Node.js tramite NVM (se non presente)
function install_node_nvm() {
	if command -v node &>/dev/null; then
		log_info "Node.js is already installed."
	else
		log_info "Node.js not found. Installing NVM and Node.js..."

		# Installa NVM
		if [ ! -d "$HOME/.nvm" ]; then
			curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
		fi

		# Source NVM
		export NVM_DIR="$HOME/.nvm"
		# shellcheck source=/dev/null
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

		# Installa Node LTS
		nvm install --lts
		nvm use --lts

		log_success "Node.js and NVM installed."
	fi
}

# 3. Installa pnpm (se non presente)
function install_pnpm() {
	if command -v pnpm &>/dev/null; then
		log_info "pnpm is already installed."
	else
		log_info "Installing pnpm globally via npm..."
		npm install -g pnpm
		log_success "pnpm installed."
	fi
}

# 4. Esegui bootstrap CLI shell temporaneo (solo se necessario)
function run_shell_bootstrap() {
	if [ -f "$CLI_SH_DISPATCH" ]; then
		log_info "Running shell bootstrap (bin/cli-sh)..."
		bash "$CLI_SH_DISPATCH" bootstrap
		log_success "Shell bootstrap completed."
	else
		log_info "Shell bootstrap script not found, skipping."
	fi
}

# 5. Installa o aggiorna CLI TypeScript (nx monorepo)
function install_cli_ts() {
	log_info "Installing/updating DevKitX CLI (TypeScript)..."

	cd "$ROOT_DIR"

	# Usa pnpm per installare dipendenze
	pnpm install

	# Build CLI TS con Nx o direttamente con tsc (dipende da configurazione)
	pnpm nx build devkitx

	log_success "DevKitX CLI installed and built."
}

# Main orchestration
function main() {
	log_info "Starting DevKitX bootstrap installation..."

	check_prerequisites
	install_node_nvm
	install_pnpm
	run_shell_bootstrap
	install_cli_ts

	log_success "DevKitX bootstrap completed successfully!"
	echo
	echo "You can now run the CLI using:"
	echo "  pnpm nx run devkitx:serve"
	echo "or after global install"
	echo "  devkitx"
}

main "$@"
