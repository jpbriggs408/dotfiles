#!/bin/bash
# Block GitHub write operations (POST/PATCH/PUT/DELETE via gh api, and gh pr edit/comment/review/merge/close)
# from auto-proceeding. Forces an explicit approval prompt for any matching command.
cmd=$(jq -r '.tool_input.command // ""')
if echo "$cmd" | grep -qE 'gh api.* (-X|--method) (POST|PATCH|PUT|DELETE)|gh pr (edit|comment|review|merge|close)|gh issue (comment|create|close)'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"GitHub write operation - requires explicit approval"}}'
fi
