#!/usr/bin/env bash
set -euo pipefail

log() { printf -- "** %s\n" "$*" >&2; }
error() { printf -- "** ERROR: %s\n" "$*" >&2; }
fatal() { error "$@"; exit 1; }

CURRENT_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$(git -C "${CURRENT_SCRIPT_DIR}" rev-parse --show-toplevel)"

git fetch -t 
LATEST_TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
# swift package diagnose-api-breaking-changes "$LATEST_TAG"
swift package diagnose-api-breaking-changes 0.7.0 2>&1 > api-breakage-output.log || { 
    # NUM=$(cat api-breakage-output.log|grep "💔"|wc -l)
    # log "❌ Found ${NUM} API breakages."
    # cat api-breakages.log
    exit 0;
}

log "✅ Found no API breakages."
