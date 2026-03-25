#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
PERCENT_USED=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d'.' -f1)

COST_FMT=$(printf "%.2f" "$COST")

# Compact 10-char bar
BAR_WIDTH=10
FILLED=$((PERCENT_USED * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))

if [ "$PERCENT_USED" -lt 50 ]; then
    COLOR="\033[32m"
elif [ "$PERCENT_USED" -lt 80 ]; then
    COLOR="\033[33m"
else
    COLOR="\033[31m"
fi
RESET="\033[0m"

BAR="${COLOR}"
for ((i=0; i<FILLED; i++)); do BAR+="█"; done
for ((i=0; i<EMPTY; i++)); do BAR+="░"; done
BAR+="${RESET}"

echo -e "$MODEL $BAR ${PERCENT_USED}% \$${COST_FMT}"
