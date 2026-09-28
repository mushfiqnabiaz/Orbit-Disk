#!/usr/bin/env bash
# ==============================================================================
# Orbit-Disk Installer
# curl -fsSL https://raw.githubusercontent.com/mushfiqnabiaz/orbit-disk/main/install.sh | bash
# ==============================================================================

set -e

INSTALL_DIR="${HOME}/.local/bin"
REPO_URL="https://github.com/mushfiqnabiaz/orbit-disk.git"
CLONE_DIR="${HOME}/.orbit-disk"

echo "🛰️  Installing Orbit-Disk..."

# 1. Create install directory
mkdir -p "$INSTALL_DIR"

# 2. Copy/symlink CLI executable
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$SCRIPT_DIR/bin/orbit-disk" ]; then
    cp "$SCRIPT_DIR/bin/orbit-disk" "$INSTALL_DIR/orbit-disk"
    ln -sf "$INSTALL_DIR/orbit-disk" "$INSTALL_DIR/orbit"
    chmod +x "$INSTALL_DIR/orbit-disk"
    cp "$SCRIPT_DIR/orbit-disk.plugin.zsh" "${HOME}/.orbit-disk.plugin.zsh"
else
    # Fallback to remote git clone if running via curl pipe
    rm -rf "$CLONE_DIR"
    git clone --depth=1 "$REPO_URL" "$CLONE_DIR"
    cp "$CLONE_DIR/bin/orbit-disk" "$INSTALL_DIR/orbit-disk"
    ln -sf "$INSTALL_DIR/orbit-disk" "$INSTALL_DIR/orbit"
    chmod +x "$INSTALL_DIR/orbit-disk"
    cp "$CLONE_DIR/orbit-disk.plugin.zsh" "${HOME}/.orbit-disk.plugin.zsh"
fi

# 3. Add to shell configuration
ZSHRC="${HOME}/.zshrc"
SOURCE_LINE="[ -f \"${HOME}/.orbit-disk.plugin.zsh\" ] && source \"${HOME}/.orbit-disk.plugin.zsh\""

if [ -f "$ZSHRC" ] && ! grep -q "orbit-disk.plugin.zsh" "$ZSHRC"; then
    echo "" >> "$ZSHRC"
    echo "# Orbit-Disk satellite cache offloader" >> "$ZSHRC"
    echo "$SOURCE_LINE" >> "$ZSHRC"
    echo "✅ Added Orbit-Disk hook to $ZSHRC"
fi

# 4. Initialize configuration
"$INSTALL_DIR/orbit-disk" init

echo ""
echo "🎉 Orbit-Disk has been successfully installed!"
echo "👉 Run 'source ~/.zshrc' to apply immediately."
