#!/bin/bash
# Force confirmation for destructive git operations when the target repo has
# uncommitted changes to lose. Clean repo: these commands are harmless and
# pass through silently. Dirty repo: ask instead of silently proceeding.
cmd=$(jq -r '.tool_input.command // ""')
if echo "$cmd" | grep -qE 'git reset --hard|git clean -f|git checkout -- \.|git checkout \.$|git branch -D'; then
  repo_dir=$(echo "$cmd" | grep -oE 'git -C [^ ]+' | awk '{print $3}')
  repo_dir="${repo_dir:-.}"
  if [ -n "$(git --no-optional-locks -C "$repo_dir" status --porcelain 2>/dev/null)" ]; then
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"Destructive git operation with uncommitted changes present in %s - confirm this is intentional"}}' "$repo_dir"
  fi
fi
