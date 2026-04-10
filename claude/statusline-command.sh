#!/bin/sh
# Claude Code status line — mirrors oh-my-posh omp.toml style

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Colors matching omp.toml palette
blue='\033[38;2;119;154;215m'
grey='\033[38;2;108;108;108m'
magenta='\033[38;2;158;135;207m'
cyan='\033[36m'
reset='\033[0m'

# Path segment (blue, full path)
printf "${blue}%s${reset}" "$cwd"

# Git segment (grey) — skip optional locks for safety
if git_dir=$(git -C "$cwd" rev-parse --git-dir --no-optional-locks 2>/dev/null | head -1); then
    branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
    dirty=$(git -C "$cwd" status --porcelain --no-optional-locks 2>/dev/null)
    ahead=$(git -C "$cwd" rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
    behind=$(git -C "$cwd" rev-list --count HEAD..@{u} 2>/dev/null || echo 0)

    git_info=" ${branch}"
    [ -n "$dirty" ] && git_info="${git_info}*"
    [ "$behind" -gt 0 ] 2>/dev/null && git_info="${git_info} ${cyan}⇣${reset}"
    [ "$ahead" -gt 0 ] 2>/dev/null && git_info="${git_info} ${cyan}⇡${reset}"

    printf " ${grey}%s${reset}" "$git_info"
fi

# Model name (magenta)
if [ -n "$model" ]; then
    printf " ${magenta}%s${reset}" "$model"
fi

# Context usage
if [ -n "$used" ]; then
    printf " ${grey}ctx:%.0f%%${reset}" "$used"
fi

printf '\n'
