# ==============================================================================
# orbit-disk.plugin.zsh - Satellite Storage Offloader for Zsh / Oh My Zsh (v1.1.0)
# https://github.com/mushfiqnabiaz/orbit-disk
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

export PATH="$PNPM_HOME:$PATH"

# Quick Shortcuts
alias orbit-sweep="orbit-disk sweep"
alias orbit-status="orbit-disk status"
alias orbit="orbit-disk"
