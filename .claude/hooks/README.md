# Claude Code Hooks

## suggest-reflect.sh

**Purpose:** Analyzes your session for discoveries or fixes and suggests running `/reflect` to capture learnings to project documentation.

**How it works:**
- Runs automatically when you end a session
- Looks for keywords like: fixed, workaround, gotcha, discovered, realized, turns out
- Also detects softer signals: error, bug, issue, problem, fail

**How to disable this hook:**

Choose one of these approaches:

1. **Remove the entire hooks section from `.claude/settings.json`:**
   ```bash
   # Edit .claude/settings.json and delete the "hooks" section
   ```

2. **Clear the hooks array via Claude Code:**
   ```
   /update-config hooks.Stop []
   ```

3. **Delete the hook script:**
   ```bash
   rm .claude/hooks/suggest-reflect.sh
   ```

After disabling, the hook will no longer run on session end.
