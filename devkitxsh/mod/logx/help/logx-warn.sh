#!/usr/bin/env bash
# Help for logx-warn

logx::help::warn() {
	echo ""
	echo "⚠️ logx-warn — Print a warning message"
	echo ""
	echo "USAGE:"
	echo "  logx-warn [options] <message>"
	echo ""
	echo "OPTIONS:"
	echo "  --plain          Disable emoji"
	echo "  --quiet, -q      Silence all output"
	echo "  --abort          Exit after printing"
	echo "  --exit-code [n]  Exit with custom code (default: 1)"
	echo "  -h, --help       Show this help"
	echo ""
	echo "EXAMPLES:"
	echo "  logx-warn 'Low disk space!'"
	echo "  logx-warn --plain 'This is a minimal warning'"
	echo "  logx-warn --abort --exit-code 2 'Critical warning'"
	echo ""
}
