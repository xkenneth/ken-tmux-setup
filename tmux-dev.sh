#!/bin/bash

DIR="${1:-.}"
DIR="$(cd "$DIR" && pwd)"

SESSION="Dev"

# Kill tmux server to start fresh (removes all sessions)
tmux kill-server 2>/dev/null
sleep 0.5

# ============================================
# Window 1: Dev (index 1, created with session)
# Layout: 3 even vertical columns
# ============================================
tmux new-session -d -s "$SESSION" -n "Dev" -c "$DIR"

# Split into 3 columns
tmux split-window -h -t "$SESSION:1" -c "$DIR"
tmux split-window -h -t "$SESSION:1" -c "$DIR"
tmux select-layout -t "$SESSION:1" even-horizontal

# Name the panes (1-based indexing)
tmux select-pane -t "$SESSION:1.1" -T "Agent 1"
tmux select-pane -t "$SESSION:1.2" -T "Agent 2"
tmux select-pane -t "$SESSION:1.3" -T "Agent 3"
tmux select-pane -t "$SESSION:1.1"

# ============================================
# Window 2: Dev2
# Layout: 3 even vertical columns
# ============================================
tmux new-window -t "$SESSION:2" -n "Dev2" -c "$DIR"

tmux split-window -h -t "$SESSION:2" -c "$DIR"
tmux split-window -h -t "$SESSION:2" -c "$DIR"
tmux select-layout -t "$SESSION:2" even-horizontal

tmux select-pane -t "$SESSION:2.1" -T "Agent 4"
tmux select-pane -t "$SESSION:2.2" -T "Agent 5"
tmux select-pane -t "$SESSION:2.3" -T "Agent 6"
tmux select-pane -t "$SESSION:2.1"

# ============================================
# Window 3: Orchestration
# Layout: 3 columns - left tall, middle 3-split, right 3-split
# ============================================
tmux new-window -t "$SESSION:3" -n "Orchestration" -c "$DIR"

# Split into 3 columns
tmux split-window -h -t "$SESSION:3" -c "$DIR"
tmux split-window -h -t "$SESSION:3" -c "$DIR"

# Split middle column into 3 vertical panes
tmux select-pane -t "$SESSION:3.2"
tmux split-window -v -t "$SESSION:3.2" -c "$DIR"
tmux split-window -v -t "$SESSION:3.2" -c "$DIR"

# Split right column into 3 vertical panes
tmux select-pane -t "$SESSION:3.5"
tmux split-window -v -t "$SESSION:3.5" -c "$DIR"
tmux split-window -v -t "$SESSION:3.5" -c "$DIR"

# Resize columns
tmux select-layout -t "$SESSION:3" even-horizontal

# Name the panes
tmux select-pane -t "$SESSION:3.1" -T "Main"
tmux select-pane -t "$SESSION:3.2" -T "Middle 1"
tmux select-pane -t "$SESSION:3.3" -T "Middle 2"
tmux select-pane -t "$SESSION:3.4" -T "Middle 3"
tmux select-pane -t "$SESSION:3.5" -T "Right 1"
tmux select-pane -t "$SESSION:3.6" -T "Right 2"
tmux select-pane -t "$SESSION:3.7" -T "Right 3"
tmux select-pane -t "$SESSION:3.1"

# ============================================
# Window 4: Plan
# Layout: Single full-screen pane
# ============================================
tmux new-window -t "$SESSION:4" -n "Plan" -c "$DIR"
tmux select-pane -t "$SESSION:4.1" -T "Plan"

# Switch to first window and attach
tmux select-window -t "$SESSION:1"
tmux attach -t "$SESSION"
