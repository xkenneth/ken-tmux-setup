#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Ken's tmux setup installer"
echo "=========================="

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Linux*)  OS_TYPE="linux";;
    Darwin*) OS_TYPE="macos";;
    *)       echo "Unsupported OS: $OS"; exit 1;;
esac
echo "Detected OS: $OS_TYPE"

# Install tmux and dependencies
install_deps() {
    echo "Installing dependencies..."
    if [ "$OS_TYPE" = "macos" ]; then
        if ! command -v brew &>/dev/null; then
            echo "Homebrew not found. Please install it first: https://brew.sh"
            exit 1
        fi
        brew install tmux
    elif [ "$OS_TYPE" = "linux" ]; then
        if command -v apt-get &>/dev/null; then
            sudo apt-get update
            sudo apt-get install -y tmux xsel xclip
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y tmux xsel xclip
        elif command -v pacman &>/dev/null; then
            sudo pacman -S --noconfirm tmux xsel xclip
        else
            echo "Could not detect package manager. Please install tmux manually."
            exit 1
        fi
    fi
}

# Install Oh My Tmux
install_oh_my_tmux() {
    echo "Installing Oh My Tmux..."
    if [ -d "$HOME/.oh-my-tmux" ]; then
        echo "Oh My Tmux already installed, updating..."
        cd "$HOME/.oh-my-tmux" && git pull
    else
        git clone https://github.com/gpakosz/.tmux.git "$HOME/.oh-my-tmux"
    fi

    # Backup existing configs
    if [ -f "$HOME/.tmux.conf" ] && [ ! -L "$HOME/.tmux.conf" ]; then
        echo "Backing up existing .tmux.conf to .tmux.conf.backup"
        mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup.$(date +%s)"
    fi
    if [ -f "$HOME/.tmux.conf.local" ] && [ ! -L "$HOME/.tmux.conf.local" ]; then
        echo "Backing up existing .tmux.conf.local to .tmux.conf.local.backup"
        mv "$HOME/.tmux.conf.local" "$HOME/.tmux.conf.local.backup.$(date +%s)"
    fi

    # Create symlinks
    ln -sf "$HOME/.oh-my-tmux/.tmux.conf" "$HOME/.tmux.conf"
    ln -sf "$REPO_DIR/.tmux.conf.local" "$HOME/.tmux.conf.local"
    echo "Symlinked tmux configs"
}

# Install helper scripts
install_scripts() {
    echo "Installing helper scripts..."
    mkdir -p "$HOME/.local/bin"
    ln -sf "$REPO_DIR/tmux-dev.sh" "$HOME/.local/bin/tmux-dev"
    chmod +x "$REPO_DIR/tmux-dev.sh"
    echo "Installed tmux-dev to ~/.local/bin/tmux-dev"
    echo "Make sure ~/.local/bin is in your PATH"
}

# Main
if ! command -v tmux &>/dev/null; then
    install_deps
else
    echo "tmux already installed: $(tmux -V)"
fi

install_oh_my_tmux
install_scripts

echo ""
echo "Installation complete!"
echo ""
echo "Features enabled:"
echo "  - Mouse support (on by default)"
echo "  - Vi mode for copy/paste"
echo "  - Pane titles displayed"
echo "  - Session persistence (tmux-resurrect + continuum)"
echo "  - System clipboard integration"
echo ""
echo "Usage:"
echo "  tmux-dev [dir]  - Launch dev environment with multi-pane layout"
echo ""
echo "Reload tmux config: prefix + r"
echo "Toggle mouse: prefix + m"
