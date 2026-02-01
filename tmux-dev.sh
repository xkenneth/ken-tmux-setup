#!/bin/bash

DIR="${1:-.}"
DIR="$(cd "$DIR" && pwd)"

SESSION="Dev"

# Kill existing session
tmux kill-session -t "$SESSION" 2>/dev/null && echo "Killed session '$SESSION'"

# ============================================
# Window 1: Dev
# Layout: 3 even vertical columns
# ============================================
tmux new-session -d -s "$SESSION" -n "Dev" -c "$DIR"

# Split into 3 columns
tmux split-window -h -t "$SESSION:Dev" -c "$DIR"
tmux split-window -h -t "$SESSION:Dev" -c "$DIR"

# Resize to equal widths
tmux select-layout -t "$SESSION:Dev" even-horizontal

# Name the panes
tmux select-pane -t "$SESSION:Dev.0" -T "Agent 1"
tmux select-pane -t "$SESSION:Dev.1" -T "Agent 2"
tmux select-pane -t "$SESSION:Dev.2" -T "Agent 3"

# Select the left pane
tmux select-pane -t "$SESSION:Dev.0"

# ============================================
# Window 2: Dev2
# Layout: 3 even vertical columns
# ============================================
tmux new-window -t "$SESSION" -n "Dev2" -c "$DIR"

# Split into 3 columns
tmux split-window -h -t "$SESSION:Dev2" -c "$DIR"
tmux split-window -h -t "$SESSION:Dev2" -c "$DIR"

# Resize to equal widths
tmux select-layout -t "$SESSION:Dev2" even-horizontal

# Name the panes
tmux select-pane -t "$SESSION:Dev2.0" -T "Agent 4"
tmux select-pane -t "$SESSION:Dev2.1" -T "Agent 5"
tmux select-pane -t "$SESSION:Dev2.2" -T "Agent 6"

# Select the left pane
tmux select-pane -t "$SESSION:Dev2.0"

# ============================================
# Window 3: Orchestration
# Layout: 3 columns - left tall, middle 3-split, right 3-split
# ============================================
tmux new-window -t "$SESSION" -n "Orchestration" -c "$DIR"

# Split into 3 columns
tmux split-window -h -t "$SESSION:Orchestration" -c "$DIR"
tmux split-window -h -t "$SESSION:Orchestration" -c "$DIR"

# Split middle column (pane 1) into 3 vertical panes
tmux select-pane -t "$SESSION:Orchestration.1"
tmux split-window -v -t "$SESSION:Orchestration" -c "$DIR"
tmux split-window -v -t "$SESSION:Orchestration" -c "$DIR"

# Split right column (now pane 4) into 3 vertical panes
tmux select-pane -t "$SESSION:Orchestration.4"
tmux split-window -v -t "$SESSION:Orchestration" -c "$DIR"
tmux split-window -v -t "$SESSION:Orchestration" -c "$DIR"

# Resize columns to equal widths
tmux resize-pane -t "$SESSION:Orchestration.0" -x 33%
tmux resize-pane -t "$SESSION:Orchestration.1" -x 33%

# Name the panes
tmux select-pane -t "$SESSION:Orchestration.0" -T "Main"
tmux select-pane -t "$SESSION:Orchestration.1" -T "Middle 1"
tmux select-pane -t "$SESSION:Orchestration.2" -T "Middle 2"
tmux select-pane -t "$SESSION:Orchestration.3" -T "Middle 3"
tmux select-pane -t "$SESSION:Orchestration.4" -T "Right 1"
tmux select-pane -t "$SESSION:Orchestration.5" -T "Right 2"
tmux select-pane -t "$SESSION:Orchestration.6" -T "Right 3"

# Select the left pane
tmux select-pane -t "$SESSION:Orchestration.0"

# ============================================
# Window 4: Plan
# Layout: Single full-screen pane
# ============================================
tmux new-window -t "$SESSION" -n "Plan" -c "$DIR"
tmux select-pane -t "$SESSION:Plan.0" -T "Plan"

# Switch to first window and attach
tmux select-window -t "$SESSION:Dev"
tmux attach -t "$SESSION"
