#!/usr/bin/env zsh
#
#  start-watcher.zsh
#  GitHubWatcher
#
#  Created by Devyn Ferman on 4/16/26.
#
#  Usage:
#    ./start-watcher.zsh <github-username> <GitHub Auth Token> [Options]
#
#  The GitHub token is read from the GITHUB_TOKEN environment variable,
#  or can be passed as a second positional argument (less secure).
#
#  Options (passed through to GitHubWatcher):
#    --wait <minutes>         Poll interval in minutes        (default: 5)
#    --watch-timeout <hours>  Session duration before exit    (default: 8)
#    --port <path>            Arduino serial port path        (default: /dev/cu.usbserial-210)
#
#  Example:
#    GITHUB_TOKEN=ghp_xxx ./start-watcher.zsh devyn
#    ./start-watcher.zsh devyn ghp_xxx --wait 10 --port /dev/cu.usbserial-110

set -euo pipefail

# ── Resolve package root (two levels up from this script) ────────────────────
SCRIPT_DIR="${0:A:h}"
PACKAGE_ROOT="${SCRIPT_DIR:h:h}"

# ── Parse positional arguments ───────────────────────────────────────────────
if [[ $# -lt 1 ]]; then
    print -u2 "Usage: $0 <github-username> [github-token] [--wait N] [--watch-timeout N] [--port PATH]"
    exit 1
fi

GH_USERNAME="$1"
shift

# Token: second positional arg OR $GITHUB_TOKEN env var
if [[ $# -gt 0 && "${1}" != --* ]]; then
    GH_TOKEN="$1"
    shift
elif [[ -n "${GITHUB_TOKEN:-}" ]]; then
    GH_TOKEN="$GITHUB_TOKEN"
else
    print -u2 "Error: GitHub token required. Pass it as a second argument or set GITHUB_TOKEN."
    exit 1
fi

# Remaining args are flags forwarded directly to the Swift binary
PASSTHROUGH_ARGS=("$@")

# ── Build ────────────────────────────────────────────────────────────────────
print "Building GitHubWatcher..."
swift build -c release --package-path "$PACKAGE_ROOT" 2>&1

BINARY="${PACKAGE_ROOT}/.build/release/GitHubWatcher"

if [[ ! -x "$BINARY" ]]; then
    print -u2 "Error: Build succeeded but binary not found at $BINARY"
    exit 1
fi

# ── Launch ───────────────────────────────────────────────────────────────────
print "Starting GitHubWatcher for user: ${USERNAME}"
exec "$BINARY" "$GH_USERNAME" "$GH_TOKEN" "${PASSTHROUGH_ARGS[@]}"
