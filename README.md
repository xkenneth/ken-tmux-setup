# Ken's tmux Setup

Cross-platform tmux configuration based on [Oh My Tmux](https://github.com/gpakosz/.tmux).

## Quick Install

```bash
git clone https://github.com/xkenneth/ken-tmux-setup.git
cd ken-tmux-setup
./install.sh
```

## What's Included

### Configuration (`.tmux.conf.local`)

- **Mouse support** enabled by default
- **Vi mode** for status keys and copy mode
- **Pane titles** displayed in border
- **System clipboard** integration (works on macOS and Linux)
- **Session persistence** via tmux-resurrect and tmux-continuum
- **10,000 line** history limit

### Dev Environment Script (`tmux-dev.sh`)

Multi-pane layout for development:

```
Window 1: Dev
┌─────────────┬─────────────┬─────────────┐
│             │             │  Frontend   │
│  Agent One  │  Agent Two  ├─────────────┤
│             │             │  Frontend   │
│             │             ├─────────────┤
│             │             │  Backend    │
│             │             ├─────────────┤
│             │             │  Backend    │
└─────────────┴─────────────┴─────────────┘

Window 2: Orchestration
┌─────────────┬─────────────┬─────────────┐
│             │             │             │
│ Agent Three │ Agent Mail  │   Beads     │
│             │             │             │
└─────────────┴─────────────┴─────────────┘
```

Usage:
```bash
tmux-dev [directory]
```

## Key Bindings

| Binding | Action |
|---------|--------|
| `prefix + r` | Reload config |
| `prefix + m` | Toggle mouse |
| `prefix + [` | Previous session |
| `prefix + ]` | Next session |
| `prefix + e` | Edit local config |

Default prefix is `Ctrl+b` (also `Ctrl+a`).

## Requirements

- tmux 3.0+
- git
- Linux: xsel or xclip (for clipboard)
- macOS: works out of the box

## Manual Installation

If you prefer not to use the install script:

1. Install [Oh My Tmux](https://github.com/gpakosz/.tmux)
2. Copy `.tmux.conf.local` to `~/.tmux.conf.local`
3. Optionally copy `tmux-dev.sh` to your PATH
