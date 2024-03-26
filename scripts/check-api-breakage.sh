#!/usr/bin/env bash
set -eu

log() { printf -- "** %s\n" "$*" >&2; }
error() { printf -- "** ERROR: %s\n" "$*" >&2; }
fatal() { error "$@"; exit 1; }

CURRENT_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$(git -C "${CURRENT_SCRIPT_DIR}" rev-parse --show-toplevel)"

git fetch -t 
LATEST_TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
#swift package diagnose-api-breaking-changes "$LATEST_TAG"
swift package diagnose-api-breaking-changes 0.7.0 2>&1 > api.log
cat api.log

# if [ "${NUM_BROKEN_SYMLINKS}" -gt 0 ]; then
#   fatal "❌ Found ${NUM_BROKEN_SYMLINKS} symlinks."
# fi
#log "✅ Found no api breakage."
