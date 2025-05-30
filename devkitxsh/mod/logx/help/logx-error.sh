#!/usr/bin/env bash
# Help for logx-error

logx::help::error() {
	echo ""
	echo "❌ logx-error — Print an error message"
	echo ""
	echo "USAGE:"
	echo "  logx-error [options] <message>"
	echo ""
	echo "OPTIONS:"
	echo "  --plain          Disable emoji"
	echo "  --quiet, -q      Silence all output"
	echo "  --abort          Exit after printing"
	echo "  --exit-code [n]  Exit with custom code (default: 1)"
	echo "  -h, --help       Show this help"
	echo ""
	echo "EXAMPLES:"
	echo "  logx-error 'Something went wrong!'"
	echo "  logx-error --plain 'Minimal error output'"
	echo "  logx-error --abort --exit-code 3 'Critical failure'"
	echo ""
}
