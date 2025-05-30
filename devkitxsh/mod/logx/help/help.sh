#!/usr/bin/env bash
# logx/help/help.sh — Main help section for logx

logx::help::main() {
	local quiet="${LOGX_QUIET:-false}"
	local emoji="${LOGX_PLAIN:-false}" && [[ "${DEVKITX_EMOJI:-true}" == "false" ]] && emoji=true

	$quiet && return 0

	local icon_info="ℹ️"
	local icon_warn="⚠️"
	local icon_error="❌"
	local icon_success="✅"
	local icon_bullet="•"
	local icon_heading="🛠️"

	$emoji && icon_info="" && icon_warn="" && icon_error="" && icon_success="" && icon_bullet="" && icon_heading=""

	echo ""
	echo "  ${icon_heading} logx — Styled logger utility for shell environments"
	echo ""
	echo "USAGE:"
	echo "  logx [command] [options] <message>"
	echo ""
	echo "COMMANDS:"
	echo "  ${icon_success} success, --success, -ok      Show success messages"
	echo "  ${icon_warn} warn, --warn, -w               Show warning messages"
	echo "  ${icon_error} error, --error, -e            Show error messages"
	echo ""
	echo "OPTIONS:"
	echo "  ${icon_bullet} --plain                     Disable emoji"
	echo "  ${icon_bullet} --quiet, -q                 Silence all output"
	echo "  ${icon_bullet} --abort                     Exit after output"
	echo "  ${icon_bullet} --exit-code [n]             Exit with specific code (default: 1)"
	echo "  ${icon_bullet} -h, --help, help            Show command-specific help"
	echo ""
	echo "EXAMPLES:"
	echo "  logx --success 'Everything is working!'"
	echo "  logx -w --abort 'Careful, something is off'"
	echo "  logx -e --exit-code 3 'Fatal error occurred'"
	echo ""
	echo "NOTES:"
	echo "  • Can be used standalone via 'logx-success', 'logx-warn', 'logx-error'"
	echo "  • Supports both Bash and Zsh environments"
	echo ""
}
