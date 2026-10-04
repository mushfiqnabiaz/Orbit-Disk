# ==============================================================================
# orbit-disk.fish - Satellite Storage Offloader for Fish Shell (v1.2.0)
# https://github.com/mushfiqnabiaz/Orbit-Disk
# ==============================================================================

function _orbit_disk_get_target
    set -l conf "$HOME/.orbit-disk.conf"
    set -l drive "auto"

    if test -f "$conf"
        set -l parsed (grep -E "^ORBIT_PATH=" "$conf" | cut -d'=' -f2- | tr -d '"' | tr -d "'")
        test -n "$parsed"; and set drive "$parsed"
    end

    if test "$drive" != "auto" -a -d "$drive"
        echo "$drive"
        return 0
    end

    for vol in /Volumes/*
        test "$vol" = "/Volumes/Macintosh HD"; and continue
        test "$vol" = "/Volumes/Macintosh HD - Data"; and continue
        test ! -d "$vol"; and continue
        test ! -w "$vol"; and continue
        test -f "$vol/.read-only"; and continue

        echo "$vol"
        return 0
    end

    return 1
end

set -g _ORBIT_DISK_TARGET (_orbit_disk_get_target)

if test -n "$_ORBIT_DISK_TARGET" -a -d "$_ORBIT_DISK_TARGET"
    # --- Drive Docked: Route Heavy Caches to Satellite Volume ---
    set -gx XDG_CACHE_HOME "$_ORBIT_DISK_TARGET/.cache"
    set -gx HOMEBREW_CACHE "$_ORBIT_DISK_TARGET/Caches/Homebrew"

    # Package Managers
    set -gx NPM_CONFIG_CACHE "$_ORBIT_DISK_TARGET/.npm-cache"
    set -gx PNPM_HOME "$_ORBIT_DISK_TARGET/.pnpm"
    set -gx BUN_INSTALL_CACHE_DIR "$_ORBIT_DISK_TARGET/.bun-cache"

    # Android & Gradle
    set -gx ANDROID_USER_HOME "$_ORBIT_DISK_TARGET/.android"
    set -gx ANDROID_AVD_HOME "$_ORBIT_DISK_TARGET/.android/avd"
    set -gx ANDROID_EMULATOR_HOME "$_ORBIT_DISK_TARGET/.android"
    set -gx GRADLE_USER_HOME "$_ORBIT_DISK_TARGET/.gradle"

    # Compilers & Toolchains
    set -gx GOCACHE "$_ORBIT_DISK_TARGET/Caches/go-build"
    set -gx CARGO_HOME "$_ORBIT_DISK_TARGET/.cargo"
    set -gx PLAYWRIGHT_BROWSERS_PATH "$_ORBIT_DISK_TARGET/Caches/ms-playwright"

    # Local AI Model Weights
    set -gx OLLAMA_MODELS "$_ORBIT_DISK_TARGET/ollama/models"
    set -gx HF_HOME "$_ORBIT_DISK_TARGET/.cache/huggingface"
    set -gx TORCH_HOME "$_ORBIT_DISK_TARGET/.cache/torch"

    if test -d "$_ORBIT_DISK_TARGET/Projects"
        alias cdp="cd '$_ORBIT_DISK_TARGET/Projects'"
    end
else
    # --- Drive Undocked: Transparent Internal Fallback ---
    set -e XDG_CACHE_HOME
    set -e HOMEBREW_CACHE
    set -e NPM_CONFIG_CACHE
    set -gx PNPM_HOME "$HOME/Library/pnpm"
    set -e BUN_INSTALL_CACHE_DIR

    set -e ANDROID_USER_HOME
    set -e ANDROID_AVD_HOME
    set -e ANDROID_EMULATOR_HOME
    set -gx GRADLE_USER_HOME "$HOME/.gradle"

    set -e GOCACHE
    set -gx CARGO_HOME "$HOME/.cargo"
    set -e PLAYWRIGHT_BROWSERS_PATH
    set -e OLLAMA_MODELS
    set -e HF_HOME
    set -e TORCH_HOME
end

if test -n "$PNPM_HOME" -a -d "$PNPM_HOME"
    fish_add_path "$PNPM_HOME"
end

if test -d "$HOME/.local/bin"
    fish_add_path "$HOME/.local/bin"
end

# Quick Shortcuts
alias orbit-offload="orbit-disk offload-all"
alias orbit-offload-all="orbit-disk offload-all"
alias orbit-android="orbit-disk android-offload"
alias orbit-gradle="orbit-disk gradle-offload"
alias orbit-cursor="orbit-disk cursor-offload"
alias orbit-xcode="orbit-disk xcode-offload"
alias orbit-docker="orbit-disk docker-offload"
alias orbit-sweep="orbit-disk sweep"
alias orbit-status="orbit-disk status"
alias orbit-stats="orbit-disk stats"
alias orbit-space="orbit-disk stats"
alias orbit-doctor="orbit-disk doctor"
alias orbit-update="orbit-disk update"
alias orbit="orbit-disk"
