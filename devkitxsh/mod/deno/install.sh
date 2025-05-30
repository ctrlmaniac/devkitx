#!/usr/bin/env bash
set -euo pipefail

# Logging
log_info() { printf "  💡  %s\n" "$*"; }
log_success() { printf "  ✅  %s\n" "$*"; }
log_warn() { printf "  ⚠️   %s\n" "$*" >&2; }
log_error() { printf "  ❌  %s\n" "$*" >&2; }

check_deno_installed() {
	if command -v deno >/dev/null 2>&1; then
		log_success "Deno is already installed at: $(command -v deno)"
		return 0
	else
		log_info "Deno is not installed. Proceeding with installation..."
		return 1
	fi
}

install_dependencies() {
	log_info "Checking for required system dependencies..."

	local missing=()
	command -v curl >/dev/null 2>&1 || missing+=("curl")
	command -v unzip >/dev/null 2>&1 || missing+=("unzip")

	if [[ ${#missing[@]} -gt 0 ]]; then
		log_info "Installing missing packages: ${missing[*]}"

		if command -v apt-get >/dev/null 2>&1; then
			sudo apt-get update -y
			sudo apt-get install -y "${missing[@]}"
		elif command -v dnf >/dev/null 2>&1; then
			sudo dnf install -y "${missing[@]}"
		elif command -v pacman >/dev/null 2>&1; then
			sudo pacman -Sy --noconfirm "${missing[@]}"
		else
			log_error "Unsupported package manager. Please install manually: ${missing[*]}"
			exit 1
		fi
	else
		log_success "All required dependencies are already installed."
	fi
}

install_deno() {
	log_info "Installing Deno from install.sh script..."
	if curl -fsSL https://deno.land/install.sh | sh; then
		log_success "Deno installed successfully."
	else
		log_warn "Initial installation failed. Fixing dependencies and retrying..."
		install_dependencies
		curl -fsSL https://deno.land/install.sh | sh
		log_success "Deno installed successfully after fixing dependencies."
	fi
}

install_vscode_extensions() {
	if ! command -v code >/dev/null 2>&1; then
		log_error "VS Code CLI ('code') not found in PATH."
		exit 1
	fi

	local extensions=(
		"denoland.vscode-deno"
		"esbenp.prettier-vscode"
		"bradlc.vscode-tailwindcss"
	)

	log_info "Installing recommended VS Code extensions for Deno..."

	for extension in "${extensions[@]}"; do
		if code --list-extensions | grep -q "^$extension$"; then
			log_success "$extension is already installed."
		else
			log_info "Installing $extension..."
			code --install-extension "$extension" --force
		fi
	done

	log_success "All recommended extensions have been installed."
}

main() {
	check_deno_installed || install_deno
	install_vscode_extensions
}

main "$@"
