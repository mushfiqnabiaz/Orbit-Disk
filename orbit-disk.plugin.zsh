# ==============================================================================
# orbit-disk.plugin.zsh - Satellite Storage Offloader for Zsh / Oh My Zsh (v1.2.0)
# https://github.com/mushfiqnabiaz/Orbit-Disk
# ==============================================================================

_orbit_disk_get_target() {
    local conf="${HOME}/.orbit-disk.conf"
    local drive="auto"

    if [ -f "$conf" ]; then
        # shellcheck source=/dev/null
        source "$conf"
        drive="${ORBIT_PATH:-auto}"
    fi

    if [ "$drive" != "auto" ] && [ -n "$drive" ] && [ -d "$drive" ]; then
        echo "$drive"
        return 0
    fi

    # Auto-detect writable mounted volume in /Volumes
    for vol in /Volumes/*; do
        if [ "$vol" = "/Volumes/Macintosh HD" ] || [ "$vol" = "/Volumes/Macintosh HD - Data" ] || [ ! -d "$vol" ]; then
            continue
        fi
        if [ -w "$vol" ] && [ ! -f "$vol/.read-only" ]; then
            echo "$vol"
            return 0
        fi
    done

    echo ""
    return 1
}

# Dynamic Environment Configuration
_ORBIT_DISK_TARGET="$(_orbit_disk_get_target || true)"

if [ -n "$_ORBIT_DISK_TARGET" ] && [ -d "$_ORBIT_DISK_TARGET" ]; then
    # --- Drive Docked: Offload Heavy Developer Caches ---
    
    # 1. Web & Package Caches
    export XDG_CACHE_HOME="$_ORBIT_DISK_TARGET/.cache"
    export HOMEBREW_CACHE="$_ORBIT_DISK_TARGET/Caches/Homebrew"
    export NPM_CONFIG_CACHE="$_ORBIT_DISK_TARGET/.npm-cache"
    export PNPM_HOME="$_ORBIT_DISK_TARGET/.pnpm"
    export BUN_INSTALL_CACHE_DIR="$_ORBIT_DISK_TARGET/.bun-cache"

    # 2. Android & Mobile Development
    export ANDROID_USER_HOME="$_ORBIT_DISK_TARGET/.android"
    export ANDROID_AVD_HOME="$_ORBIT_DISK_TARGET/.android/avd"
    export ANDROID_EMULATOR_HOME="$_ORBIT_DISK_TARGET/.android"
    export GRADLE_USER_HOME="$_ORBIT_DISK_TARGET/.gradle"

    # 3. Compilers, Runtimes & Testing
    export GOCACHE="$_ORBIT_DISK_TARGET/Caches/go-build"
    export CARGO_HOME="$_ORBIT_DISK_TARGET/.cargo"
    export PLAYWRIGHT_BROWSERS_PATH="$_ORBIT_DISK_TARGET/Caches/ms-playwright"

    # 4. Local AI Model Weights
    export OLLAMA_MODELS="$_ORBIT_DISK_TARGET/ollama/models"
    export HF_HOME="$_ORBIT_DISK_TARGET/.cache/huggingface"
    export TORCH_HOME="$_ORBIT_DISK_TARGET/.cache/torch"

    # Projects directory shortcut
    if [ -d "$_ORBIT_DISK_TARGET/Projects" ]; then
        alias cdp="cd '$_ORBIT_DISK_TARGET/Projects'"
    fi
else
    # --- Drive Undocked: Transparent Internal Fallback ---
    unset XDG_CACHE_HOME
    unset HOMEBREW_CACHE
    unset NPM_CONFIG_CACHE
    export PNPM_HOME="$HOME/Library/pnpm"
    unset BUN_INSTALL_CACHE_DIR

    # Android & Gradle Fallback
    unset ANDROID_USER_HOME
    unset ANDROID_AVD_HOME
    unset ANDROID_EMULATOR_HOME
    export GRADLE_USER_HOME="$HOME/.gradle"

    # Compilers & AI Fallback
    unset GOCACHE
    export CARGO_HOME="$HOME/.cargo"
    unset PLAYWRIGHT_BROWSERS_PATH
    unset OLLAMA_MODELS
    unset HF_HOME
    unset TORCH_HOME
fi

# Ensure ~/.local/bin is in PATH for Orbit-Disk CLI
if [[ ":$PATH:" != *":${HOME}/.local/bin:"* ]]; then
    export PATH="${HOME}/.local/bin:$PATH"
fi

export PATH="$PNPM_HOME:$PATH"

# Clear any pre-existing aliases to prevent "defining function based on alias" parse errors in Zsh
unalias orbit 2>/dev/null || true
unalias orbit-disk 2>/dev/null || true
unalias orbit-update 2>/dev/null || true

# Resilient Orbit CLI Wrapper (Auto-locates binary, fixes PATH, and auto-reloads session on update)
function orbit {
    # If updating: run update AND automatically reload ~/.zshrc into the current terminal session!
    if [ "$1" = "update" ] || [ "$1" = "upgrade" ]; then
        local ret=0
        if command -v orbit-disk >/dev/null 2>&1; then
            command orbit-disk "$@"
            ret=$?
        elif [ -x "${HOME}/.local/bin/orbit-disk" ]; then
            export PATH="${HOME}/.local/bin:$PATH"
            "${HOME}/.local/bin/orbit-disk" "$@"
            ret=$?
        else
            echo "🛰️  Orbit-Disk CLI binary is not installed on this Mac."
            echo "📥 Downloading and installing latest release from GitHub..."
            curl -fsSL https://raw.githubusercontent.com/mushfiqnabiaz/Orbit-Disk/main/install.sh | bash
            ret=$?
        fi

        # Automatically re-source and refresh current shell session without user typing it!
        export PATH="${HOME}/.local/bin:$PATH"
        rm -f "${HOME}/.orbit-disk-update-alert" 2>/dev/null || true
        if [ -f "${HOME}/.orbit-disk.plugin.zsh" ]; then
            source "${HOME}/.orbit-disk.plugin.zsh" 2>/dev/null || true
        fi
        if [ -f "${HOME}/.zshrc" ]; then
            source "${HOME}/.zshrc" 2>/dev/null || true
        fi
        echo "🔄 Automatically refreshed active shell session (~/.zshrc reloaded)!"
        return $ret
    fi

    # 1. If orbit-disk is directly available in PATH
    if command -v orbit-disk >/dev/null 2>&1; then
        command orbit-disk "$@"
        return $?
    fi

    # 2. Check standard locations
    local candidate=""
    for p in "${HOME}/.local/bin/orbit-disk" "/usr/local/bin/orbit-disk" "${_ORBIT_DISK_TARGET}/Projects/orbit-disk/bin/orbit-disk"; do
        if [ -x "$p" ]; then
            candidate="$p"
            break
        fi
    done

    if [ -n "$candidate" ]; then
        local pdir
        pdir="$(dirname "$candidate")"
        [[ ":$PATH:" != *":${pdir}:"* ]] && export PATH="${pdir}:$PATH"
        "$candidate" "$@"
        return $?
    fi

    # 3. If binary is completely missing from this Mac
    if [ "$1" = "install" ]; then
        echo "🛰️  Orbit-Disk CLI binary is not installed on this Mac."
        echo "📥 Downloading and installing latest release from GitHub..."
        curl -fsSL https://raw.githubusercontent.com/mushfiqnabiaz/Orbit-Disk/main/install.sh | bash
        export PATH="${HOME}/.local/bin:$PATH"
        rm -f "${HOME}/.orbit-disk-update-alert" 2>/dev/null || true
        [ -f "${HOME}/.zshrc" ] && source "${HOME}/.zshrc" 2>/dev/null || true
        return 0
    fi

    echo "❌ orbit-disk binary is not installed on this Mac (or not found in PATH)."
    echo "👉 Run 'orbit update' (or: curl -fsSL https://raw.githubusercontent.com/mushfiqnabiaz/Orbit-Disk/main/install.sh | bash) to install it."
    return 127
}

function orbit-disk {
    orbit "$@"
}

function orbit-update {
    orbit update "$@"
}

# Shortcuts routing to the smart wrapper
alias orbit-offload="orbit offload-all"
alias orbit-offload-all="orbit offload-all"
alias orbit-rollback="orbit rollback"
alias orbit-android="orbit android-offload"
alias orbit-gradle="orbit gradle-offload"
alias orbit-cursor="orbit cursor-offload"
alias orbit-xcode="orbit xcode-offload"
alias orbit-docker="orbit docker-offload"
alias orbit-sweep="orbit sweep"
alias orbit-status="orbit status"
alias orbit-stats="orbit stats"
alias orbit-space="orbit stats"
alias orbit-doctor="orbit doctor"
alias orbit-link="orbit link-apps"

# Non-blocking update check (runs in background once per 24 hours)
_orbit_check_update() {
    local stamp_file="${HOME}/.orbit-disk-check"
    local alert_file="${HOME}/.orbit-disk-update-alert"
    local now
    now=$(date +%s 2>/dev/null || echo 0)

    # Detect currently installed version
    local current_v="1.2.0"
    if command -v orbit-disk >/dev/null 2>&1; then
        current_v=$(command orbit-disk --version 2>/dev/null | awk '{print $NF}' | sed 's/^v//')
    elif [ -x "${HOME}/.local/bin/orbit-disk" ]; then
        current_v=$("${HOME}/.local/bin/orbit-disk" --version 2>/dev/null | awk '{print $NF}' | sed 's/^v//')
    fi

    # Show alert if a newer version was detected
    if [ -f "$alert_file" ]; then
        local remote_v
        remote_v=$(cat "$alert_file" 2>/dev/null | sed 's/^v//')
        if [ -n "$remote_v" ] && [ "$remote_v" != "$current_v" ]; then
            printf "\033[0;36m🛰️  Orbit-Disk update available (v%s)!\033[0m Run \033[1m'orbit update'\033[0m to upgrade.\n" "$remote_v"
            return 0
        else
            # Stale alert file
            rm -f "$alert_file" 2>/dev/null || true
        fi
    fi

    local last_check=0
    [ -f "$stamp_file" ] && last_check=$(cat "$stamp_file" 2>/dev/null || echo 0)

    # Check once every 24 hours (86400 seconds)
    if [ $((now - last_check)) -gt 86400 ]; then
        echo "$now" > "$stamp_file" 2>/dev/null || true
        (
            local latest
            latest=$(curl -fsSL --max-time 3 "https://raw.githubusercontent.com/mushfiqnabiaz/Orbit-Disk/main/bin/orbit-disk" 2>/dev/null | grep '^ORBIT_VERSION=' | cut -d'"' -f2)
            if [ -n "$latest" ] && [ "$latest" != "$current_v" ]; then
                echo "v$latest" > "$alert_file" 2>/dev/null || true
            fi
        ) &! 2>/dev/null || true
    fi
}

_orbit_check_update
