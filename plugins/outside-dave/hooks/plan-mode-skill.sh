#!/bin/sh
# Runs on every prompt and stays silent unless the session is in plan mode.
# Whether a skill loads is otherwise the model's judgement call, and plan mode
# is the one case that must not be missed.
#
# Verify with:
#   echo '{"permission_mode":"plan"}' | ./plan-mode-skill.sh

input=$(cat)

if printf '%s' "$input" | grep -Eq '"permission_mode"[[:space:]]*:[[:space:]]*"plan"'; then
  printf '%s' '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"This session is in plan mode. Load the outside-dave:planning skill with the Skill tool before drafting anything, and follow it for the plan you present."}}'
fi

exit 0
