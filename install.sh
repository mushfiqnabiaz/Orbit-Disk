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

# 3. Auto-detect shell profiles and configure PATH & hooks
CURRENT_SHELL="$(basename "${SHELL:-zsh}")"
DETECTED_PROFILES=()
[ -f "${HOME}/.zshrc" ] && DETECTED_PROFILES+=("${HOME}/.zshrc")
[ -f "${HOME}/.bashrc" ] && DETECTED_PROFILES+=("${HOME}/.bashrc")
[ -f "${HOME}/.bash_profile" ] && DETECTED_PROFILES+=("${HOME}/.bash_profile")

# If no profile exists yet, create default based on user shell
if [ ${#DETECTED_PROFILES[@]} -eq 0 ]; then
    if [[ "$CURRENT_SHELL" == *"zsh"* ]]; then
        touch "${HOME}/.zshrc"
        DETECTED_PROFILES+=("${HOME}/.zshrc")
    else
        touch "${HOME}/.bashrc"
        DETECTED_PROFILES+=("${HOME}/.bashrc")
    fi
fi

for prof in "${DETECTED_PROFILES[@]}"; do
    if ! grep -q '\.local/bin' "$prof" 2>/dev/null; then
        echo "" >> "$prof"
        echo '# User local binaries (Orbit-Disk CLI)' >> "$prof"
        echo 'export PATH="${HOME}/.local/bin:$PATH"' >> "$prof"
        echo "✅ Added ~/.local/bin to PATH in $(basename "$prof")"
    fi
    if ! grep -q "orbit-disk.plugin.zsh" "$prof" 2>/dev/null; then
        echo "" >> "$prof"
        echo "# Orbit-Disk satellite cache offloader" >> "$prof"
        echo "[ -f \"${HOME}/.orbit-disk.plugin.zsh\" ] && source \"${HOME}/.orbit-disk.plugin.zsh\"" >> "$prof"
        echo "✅ Added Orbit-Disk hook to $(basename "$prof")"
    fi
done

# If /usr/local/bin is writable, link system-wide for immediate availability
if [ -w "/usr/local/bin" ]; then
    ln -sf "$INSTALL_DIR/orbit-disk" "/usr/local/bin/orbit-disk" 2>/dev/null || true
    ln -sf "$INSTALL_DIR/orbit-disk" "/usr/local/bin/orbit" 2>/dev/null || true
    echo "🔗 Linked orbit to /usr/local/bin (instantly available system-wide)"
fi

# Clean up any stale update alert
rm -f "${HOME}/.orbit-disk-update-alert" 2>/dev/null || true

# 4. Initialize configuration if not already set
if [ ! -f "${HOME}/.orbit-disk.conf" ] && [ ! -f "${HOME}/.devdrive.conf" ]; then
    "$INSTALL_DIR/orbit-disk" init
else
    echo "⚙️ Existing configuration found at ~/.orbit-disk.conf (retained)."
fi

PRIMARY_RC="${DETECTED_PROFILES[0]:-${HOME}/.zshrc}"

echo ""
echo "🎉 Orbit-Disk has been successfully installed and configured!"
echo "👉 Run 'source $(basename "$PRIMARY_RC")' (or open a new terminal tab) to begin."
