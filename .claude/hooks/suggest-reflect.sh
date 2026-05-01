#!/bin/bash
PAYLOAD=$(cat)
LOG_FILE="$(dirname "$(dirname "${BASH_SOURCE[0]}")")/hook-logs.txt"

# Extract transcript_path from the JSON payload and read actual conversation text
TRANSCRIPT_PATH=$(echo "$PAYLOAD" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('transcript_path',''))" 2>/dev/null)
if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    CONTEXT=$(cat "$TRANSCRIPT_PATH")
else
    CONTEXT="$PAYLOAD"
fi

STRONG_PATTERNS="fixed|workaround|gotcha|that's wrong|check again|we already|should have|discovered|realized|turns out"
WEAK_PATTERNS="error|bug|issue|problem|fail"
ALREADY_PROMPTED="Run /reflect or ask me to save a memory"

# If we already prompted this session, don't fire again
if echo "$CONTEXT" | grep -q "$ALREADY_PROMPTED"; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Stop hook | already-prompted this session, skipping" >> "$LOG_FILE"
    echo '{"decision": "approve"}'
    exit 0
fi

if echo "$CONTEXT" | grep -qiE "$STRONG_PATTERNS"; then
    TRIGGER="strong-match"
    MSG="This session involved fixes or discoveries. Did you want to save any decisions? Run /reflect or ask me to save a memory."
    DECISION="block"
elif echo "$CONTEXT" | grep -qiE "$WEAK_PATTERNS"; then
    TRIGGER="weak-match"
    MSG="Debugging session ended. Did you learn anything non-obvious? Run /reflect or ask me to save a memory."
    DECISION="block"
else
    TRIGGER="no-match"
    MSG=""
    DECISION="approve"
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Stop hook | trigger=$TRIGGER | decision=$DECISION" >> "$LOG_FILE"

if [ "$DECISION" = "block" ]; then
    # Show a native macOS notification instead of relying on Claude's UI turn
    osascript -e "display notification \"$MSG\" with title \"Claude Code\" subtitle \"Session ended\"" 2>/dev/null || true
fi

echo '{"decision": "approve"}'
