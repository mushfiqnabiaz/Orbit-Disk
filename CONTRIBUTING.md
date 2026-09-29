# Contributing to Orbit-Disk 🛰️

First off, thank you for considering contributing to Orbit-Disk! It's people like you who make open-source developer tooling amazing.

## 🚀 Quick Setup

1. Fork the repo and clone it locally:
   ```bash
   git clone https://github.com/<your-username>/Orbit-Disk.git
   cd Orbit-Disk
   ```

2. Test your changes locally:
   ```bash
   ./bin/orbit-disk doctor
   ./bin/orbit-disk status
   ./bin/orbit-disk stats
   ```

3. Validate shell scripts syntax before submitting:
   ```bash
   bash -n bin/orbit-disk
   bash -n install.sh
   zsh -n orbit-disk.plugin.zsh
   ```

---

## 📦 Adding a New Cache or Toolchain Target

Orbit-Disk is designed to be easily extensible. If you want to add support for a new dev tool (e.g. Flutter, PyTorch, Unity):

1. **Add the environment toggle** at the top of `bin/orbit-disk` (e.g., `OFFLOAD_FLUTTER="${OFFLOAD_FLUTTER:-true}"`).
2. **Add directory creation & Spotlight protection** in `cmd_init` and `cmd_sweep`.
3. **Add the shell export** in `orbit-disk.plugin.zsh` (and fallback `unset` when undocked).
4. **Add diagnostic check** in `cmd_doctor` under `_check_tool`.
5. **Update README.md** to reflect the new capability.

---

## 🛡️ Coding Principles

- **Zero-Crash Fallback**: When an external drive is unplugged, builds or terminals must NEVER fail or crash. Always fall back gracefully to standard macOS home paths.
- **Spotlight Defense**: Always ensure newly offloaded directories contain `.metadata_never_index` to protect the host Mac from runaway indexing churn.
- **Portability**: Keep dependencies minimal (pure POSIX/Bash, Zsh, native macOS utilities).

---

## 📬 Submitting a Pull Request

1. Branch from `main`: `git checkout -b feat/my-new-offload`
2. Commit with conventional commit messages: `feat: add flutter cache offloading`
3. Push to your fork and submit a PR against `main`.
4. GitHub Actions CI will automatically test your changes on a macOS Apple Silicon runner.
