MAKEFILE_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
GIT_MESSAGE_FILE_RELATIVE := .config/git/gitmessage
GIT_MESSAGE_FILE_ABSOLUTE := $(MAKEFILE_DIR)/$(GIT_MESSAGE_FILE_RELATIVE)

.DEFAULT_GOAL := stage-copy-diff

.PHONY: set-global-commit-template
set-global-commit-template:
	@printf "ℹ️  INFO: Attempting to set global Git commit template...\n"
	@printf "    Makefile directory: %s\n" "$(MAKEFILE_DIR)"
	@printf "    Relative template path: %s\n" "$(GIT_MESSAGE_FILE_RELATIVE)"
	@printf "    Resolved absolute template file path: %s\n\n" "$(GIT_MESSAGE_FILE_ABSOLUTE)"

	@printf "ℹ️  INFO: Checking if the template file exists...\n"
	@if [ ! -f "$(GIT_MESSAGE_FILE_ABSOLUTE)" ]; then \
		printf "❌ ERROR: Commit template file not found at %s\n" "$(GIT_MESSAGE_FILE_ABSOLUTE)"; \
		printf "❌ ERROR: Please ensure the file exists and the path is correct relative to the Makefile.\n"; \
		exit 1; \
	fi
	@printf "✅ INFO: Template file found.\n\n"

	@printf "ℹ️  INFO: Setting global Git commit template...\n"
	@git config --global commit.template "$(GIT_MESSAGE_FILE_ABSOLUTE)"
	@if [ $$? -eq 0 ]; then \
		printf "✅ SUCCESS: Global Git commit template has been set to: %s\n" "$(GIT_MESSAGE_FILE_ABSOLUTE)"; \
		printf "ℹ️  INFO: You can verify this by running: git config --global commit.template\n"; \
		printf "ℹ️  INFO: Alternatively, check your global .gitconfig file (usually located at ~/.gitconfig).\n"; \
	else \
		printf "❌ ERROR: Failed to set global Git commit template. Please check your Git installation and permissions.\n"; \
		exit 1; \
	fi

.PHONY: stage-copy-diff
stage-copy-diff:
	@printf "ℹ️  INFO: Staging all changes...\n"
	@git add .
	@printf "✅ SUCCESS: All changes staged.\n\n"
	@printf "ℹ️  INFO: Generating staged diff...\n"
	@git diff --staged
	@printf "\nℹ️  INFO: Attempting to copy staged diff to clipboard...\n"
	@if command -v xclip > /dev/null; then \
		git diff --staged | xclip -selection clipboard; \
		if [ $$? -eq 0 ]; then \
			printf "✅ SUCCESS: Staged diff copied to clipboard using xclip.\n"; \
		else \
			printf "⚠️  WARNING: Failed to copy to clipboard using xclip, though xclip seems available. Staged diff printed above.\n"; \
		fi; \
	else \
		printf "⚠️  WARNING: xclip command not found. Staged diff printed above. Please install xclip (e.g., 'sudo apt install xclip') or copy manually.\n"; \
	fi
