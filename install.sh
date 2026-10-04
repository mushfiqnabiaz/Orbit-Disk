#!/usr/bin/env bash
# ==============================================================================
# Orbit-Disk Installer
# curl -fsSL https://raw.githubusercontent.com/mushfiqnabiaz/Orbit-Disk/main/install.sh | bash
# ==============================================================================

set -e

INSTALL_DIR="${HOME}/.local/bin"
REPO_URL="https://github.com/mushfiqnabiaz/Orbit-Disk.git"
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
    if [ -d "${HOME}/.config/fish" ] || command -v fish >/dev/null 2>&1; then
        mkdir -p "${HOME}/.config/fish/conf.d"
        cp "$SCRIPT_DIR/orbit-disk.fish" "${HOME}/.config/fish/conf.d/orbit-disk.fish"
        echo "🐟 Added Orbit-Disk plugin for Fish shell"
    fi
else
    # Fallback to remote git clone if running via curl pipe
    rm -rf "$CLONE_DIR"
    git clone --depth=1 "$REPO_URL" "$CLONE_DIR"
    cp "$CLONE_DIR/bin/orbit-disk" "$INSTALL_DIR/orbit-disk"
    ln -sf "$INSTALL_DIR/orbit-disk" "$INSTALL_DIR/orbit"
    chmod +x "$INSTALL_DIR/orbit-disk"
    cp "$CLONE_DIR/orbit-disk.plugin.zsh" "${HOME}/.orbit-disk.plugin.zsh"
    if [ -d "${HOME}/.config/fish" ] || command -v fish >/dev/null 2>&1; then
        mkdir -p "${HOME}/.config/fish/conf.d"
        cp "$CLONE_DIR/orbit-disk.fish" "${HOME}/.config/fish/conf.d/orbit-disk.fish"
        echo "🐟 Added Orbit-Disk plugin for Fish shell"
    fi
fi

# 3. Add to shell configuration
ZSHRC="${HOME}/.zshrc"
SOURCE_LINE="[ -f \"${HOME}/.orbit-disk.plugin.zsh\" ] && source \"${HOME}/.orbit-disk.plugin.zsh\""

if [ -f "$ZSHRC" ]; then
    if ! grep -q '\.local/bin' "$ZSHRC"; then
        echo "" >> "$ZSHRC"
        echo '# User binaries (Orbit-Disk CLI)' >> "$ZSHRC"
        echo 'export PATH="${HOME}/.local/bin:$PATH"' >> "$ZSHRC"
        echo "✅ Added ~/.local/bin to PATH in $ZSHRC"
    fi
    if ! grep -q "orbit-disk.plugin.zsh" "$ZSHRC"; then
        echo "" >> "$ZSHRC"
        echo "# Orbit-Disk satellite cache offloader" >> "$ZSHRC"
        echo "$SOURCE_LINE" >> "$ZSHRC"
        echo "✅ Added Orbit-Disk hook to $ZSHRC"
    fi
fi

# Clean up any stale update alert
rm -f "${HOME}/.orbit-disk-update-alert" 2>/dev/null || true

# 4. Initialize configuration if not already set
if [ ! -f "${HOME}/.orbit-disk.conf" ] && [ ! -f "${HOME}/.devdrive.conf" ]; then
    "$INSTALL_DIR/orbit-disk" init
else
    echo "⚙️ Existing configuration found at ~/.orbit-disk.conf (retained)."
fi

echo ""
echo "🎉 Orbit-Disk has been successfully installed!"
echo "👉 Run 'source ~/.zshrc' to apply immediately."
