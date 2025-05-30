#!/usr/bin/env bash
# Help for logx-success

logx::help::success() {
	echo ""
	echo "✅ logx-success — Print a success message"
	echo ""
	echo "USAGE:"
	echo "  logx-success [options] <message>"
	echo ""
	echo "OPTIONS:"
	echo "  --plain          Disable emoji"
	echo "  --quiet, -q      Silence all output"
	echo "  --abort          Exit after printing"
	echo "  --exit-code [n]  Exit with custom code (default: 1)"
	echo "  -h, --help       Show this help"
	echo ""
	echo "EXAMPLES:"
	echo "  logx-success 'All systems go!'"
	echo "  logx-success --plain 'Minimal message'"
	echo "  logx-success --abort --exit-code 0 'Goodbye!'"
	echo ""
}
