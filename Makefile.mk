# Get the directory where this Makefile.mk is located.
# $(lastword $(MAKEFILE_LIST)) is the path to the current makefile.
# $(dir ...) gets its directory.
# $(abspath ...) makes it an absolute path.
MAKEFILE_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

# Define the path to your gitmessage.txt file, relative to this Makefile.
GIT_MESSAGE_FILE_RELATIVE := .config/git/gitmessage

# Construct the absolute path to the gitmessage.txt file.
GIT_MESSAGE_FILE_ABSOLUTE := $(MAKEFILE_DIR)/$(GIT_MESSAGE_FILE_RELATIVE)

# Target to set the global Git commit template
# Usage: make set-global-commit-template
set-global-commit-template:
@printf "ℹ️  INFO: Attempting to set global Git commit template...\n"
@printf "    Makefile directory: %s\n" "$(MAKEFILE_DIR)"
@printf "    Relative template path: %s\n" "$(GIT_MESSAGE_FILE_RELATIVE)"
@printf "    Resolved absolute template file path: %s\n\n" "$(GIT_MESSAGE_FILE_ABSOLUTE)"

@printf "ℹ️  INFO: Checking if the template file exists...\n"
@if [ ! -f "$(GIT_MESSAGE_FILE_ABSOLUTE)" ]; then \
	$(printf "❌ ERROR: Commit template file not found at %s\n" "$(GIT_MESSAGE_FILE_ABSOLUTE)"); \
	$(printf "❌ ERROR: Please ensure the file exists and the path is correct relative to the Makefile.\n"); \
	$(exit 1); \
fi
@printf "✅ INFO: Template file found.\n\n"

@printf "ℹ️  INFO: Setting global Git commit template...\n"
@git config --global commit.template "$(GIT_MESSAGE_FILE_ABSOLUTE)"
@if [ $$? -eq 0 ]; then \
	$(printf "✅ SUCCESS: Global Git commit template has been set to: %s\n" "$(GIT_MESSAGE_FILE_ABSOLUTE)"); \
	$(printf "ℹ️  INFO: You can verify this by running: git config --global commit.template\n"); \
	$(printf "ℹ️  INFO: Alternatively, check your global .gitconfig file (usually located at ~/.gitconfig).\n"); \
else \
	$(printf "❌ ERROR: Failed to set global Git commit template. Please check your Git installation and permissions.\n"); \
	$(exit 1); \
fi

# Phony target to ensure the recipe for 'set-global-commit-template' always runs,
# regardless of whether a file with that name exists.
.PHONY: set-global-commit-template

# Optional: You could make this the default task if you run `make` without arguments
# by uncommenting the line below, or by ensuring it's the first target in the Makefile.
# .DEFAULT_GOAL := set-global-commit-template
