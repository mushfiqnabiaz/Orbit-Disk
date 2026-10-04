<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/orbit-logo-white.png">
    <source media="(prefers-color-scheme: light)" srcset="assets/orbit-logo-dark.png">
    <img alt="Orbit-Disk Logo" src="assets/orbit-logo-white.png" width="220">
  </picture>
</p>

<h1 align="center">Orbit-Disk 🛰️</h1>

<p align="center">
  <strong>Satellite Storage & Cache Offloader for macOS Developers</strong><br>
  Keep your internal Mac SSD clean. Offload massive package caches, Android AVD emulators, and local AI weights to an external SSD with zero-crash fallback when unplugged.
</p>

<p align="center">
  <a href="https://github.com/mushfiqnabiaz/Orbit-Disk/releases"><img src="https://img.shields.io/badge/release-v1.1.0-cyan.svg?style=for-the-badge&logo=github" alt="Release"></a>
  <a href="https://github.com/mushfiqnabiaz/Orbit-Disk/actions/workflows/ci.yml"><img src="https://github.com/mushfiqnabiaz/Orbit-Disk/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <img src="https://img.shields.io/badge/macOS-Apple%20Silicon%20%7C%20Intel-black.svg?style=for-the-badge&logo=apple" alt="macOS">
  <img src="https://img.shields.io/badge/shell-zsh%20%7C%20bash%20%7C%20fish-4EAA25.svg?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Shell">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-purple.svg?style=for-the-badge" alt="License: MIT"></a>
  <a href="https://www.buymeacoffee.com/mushfiqnabiaz"><img src="https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black" alt="Buy Me A Coffee"></a>
</p>

---

> [!TIP]
> **Why pay Apple $200–$400 for 256 GB of internal storage?**  
> Orbit-Disk turns any affordable external NVMe, Samsung T7, or USB-C drive into a high-speed satellite volume for your heavy developer runtimes. When you unplug and go mobile, your Mac **automatically falls back to internal storage without breaking builds or terminals.**

---

## 🎬 Terminal Walkthrough

<p align="center">
  <img src="assets/orbit-disk-demo.gif" alt="Orbit-Disk Walkthrough Demo" width="900" style="border-radius: 14px; box-shadow: 0 10px 35px rgba(0,0,0,0.6);">
</p>

---

## ⚖️ The Problem vs. Orbit-Disk

| Developer Reality | Without Orbit-Disk | With Orbit-Disk 🛰️ |
| :--- | :--- | :--- |
| **Android Emulators (AVD)** | Consumes 10–30 GB in `~/.android/avd` | Stored on external SSD; falls back gracefully |
| **Gradle & Dependencies** | Caches 15–25 GB of JARs & Kotlin daemons | Routed to satellite drive via `GRADLE_USER_HOME` |
| **Node, Bun, & PNPM** | Multi-gigabyte global package stores | Offloaded via `PNPM_HOME` & `BUN_INSTALL_CACHE_DIR` |
| **Homebrew Downloads** | 10–30 GB of bottles in `~/Library/Caches` | Offloaded to external SSD via `HOMEBREW_CACHE` |
| **Local AI Models (Ollama, HF)** | 4 GB to 40 GB per model weights | Offloaded via `OLLAMA_MODELS` & `HF_HOME` |
| **Unplugging External SSD** | ❌ **Broken paths, missing compilers, failed builds** | ✅ **Instant, silent fallback to internal drive** |
| **Spotlight Indexing** | Freezes Mac indexing millions of node files | Protected with automated `.metadata_never_index` |

---

## 📦 Supported Ecosystems & Offloaded Paths

When docked, Orbit-Disk routes heavy directories to your external drive. When undocked, your terminal transparently restores default internal paths:

```text
/Volumes/YourSSD/
├── .android/avd/              # Android Virtual Devices (8–15 GB per device)
├── .gradle/                  # Gradle wrappers, dependencies & Kotlin cache
├── .pnpm/                    # PNPM global virtual content-addressable store
├── .bun-cache/               # Bun fast install cache
├── .npm-cache/               # NPM global package download tarballs
├── .cargo/                   # Rust crates.io index, source checkouts & binaries
├── Caches/
│   ├── Homebrew/             # Homebrew formula bottles and downloaded casks
│   ├── go-build/             # Go compiler build cache
│   └── ms-playwright/        # Playwright headless browser binaries
├── ollama/models/            # Local LLM model weights (LLaMA, DeepSeek, Qwen)
├── .cache/huggingface/       # HuggingFace Transformers model checkpoints
├── Projects/                 # Your git repositories (accessible via `cdp`)
└── Applications/             # External apps symlinked into /Applications
```

---

## 🚀 Quickstart (1-Line Install)

Install Orbit-Disk with a single command (automatically detects shell, configures PATH, and reloads):

```bash
curl -fsSL https://raw.githubusercontent.com/mushfiqnabiaz/Orbit-Disk/main/install.sh | bash && source ~/.zshrc
```

*(Or open a new terminal tab after running)*

---

## 🛠️ CLI Command Matrix

You can use either `orbit-disk` or the short alias `orbit`:

```bash
orbit status             # Check satellite drive docking status & disk space
orbit stats              # Visual dashboard of space offloaded to external drive
orbit doctor             # Run diagnostic health check on drive & dev toolchains
orbit xcode-offload      # Move Xcode DerivedData build artifacts to external SSD
orbit docker-offload     # Move Docker Desktop & OrbStack virtual disk to external SSD
orbit sweep              # Pull temporary internal fallback caches to external drive
orbit update             # Upgrade Orbit-Disk to the latest release from GitHub
orbit init               # Interactively detect & switch target external drives
orbit install-app <cask> # Install a Homebrew app to external drive & link to /Applications
orbit install-dmg <file> # Install a downloaded DMG to external drive & link to /Applications
orbit clean-next         # Recursively remove .next build artifacts in current directory
orbit clean-modules      # Recursively remove node_modules in current directory
orbit help               # Show help menu
```

### 📊 Space Offload Dashboard (`orbit stats`)

```text
🛰️  Orbit-Disk Space Offload Report
📍 Target Volume: /Volumes/External
──────────────────────────────────────────────────────────────────
Category                     Size         Share
──────────────────────────────────────────────────────────────────
Installed Apps & Tools       14.72 GB     ████████████░░░░░░░░░░░░  48%
System & Homebrew Caches     12.06 GB     ██████████░░░░░░░░░░░░░░  39%
XDG & Developer Caches       2.78 GB      ██░░░░░░░░░░░░░░░░░░░░░░   9%
Node & Package Stores        826.3 MB     █░░░░░░░░░░░░░░░░░░░░░░░   2%
──────────────────────────────────────────────────────────────────
🛡️  Total Space Kept Off Internal SSD: 30.37 GB

💾 Internal Mac SSD Free:  113Gi
🛰️ Satellite Volume Free:  156Gi (33% used)
```

---

## 🏗️ How It Works (Satellite Docking Architecture)

```
        ┌────────────────────────────────────────────────────────┐
        │                     MacBook Air / Pro                  │
        └───────────────────────────┬────────────────────────────┘
                                    │
                       Is External Drive Docked?
                                    │
                   ┌────────────────┴────────────────┐
                  YES                                NO
                   │                                 │
                   ▼                                 ▼
        ┌──────────────────────┐          ┌──────────────────────┐
        │  Satellite Drive 🛰️  │          │   Internal Storage   │
        │   (/Volumes/SSD)     │          │        (~/)          │
        ├──────────────────────┤          ├──────────────────────┤
        │ • Android AVDs       │          │ • Standard fallbacks │
        │ • Gradle cache       │          │ • Zero-crash builds  │
        │ • PNPM / Bun / NPM   │          │ • Mobile on-the-go   │
        │ • Go / Cargo build   │          └──────────────────────┘
        │ • Ollama / AI models │
        │ • Homebrew bottles   │
        └──────────────────────┘
                   ▲
                   │  orbit sweep (syncs offline caches when re-docked)
                   └─────────────────────────────────┘
```

---

## ⚙️ Configuration (`~/.orbit-disk.conf`)

Customize which runtimes are offloaded:

```bash
# Target drive mount path or "auto" for dynamic detection
ORBIT_PATH="/Volumes/External"

# Mobile & Android
OFFLOAD_ANDROID=true
OFFLOAD_GRADLE=true

# Web & Package Caches
OFFLOAD_XDG_CACHE=true
OFFLOAD_HOMEBREW=true
OFFLOAD_NPM=true
OFFLOAD_PNPM=true
OFFLOAD_BUN=true

# Compilers & Testing
OFFLOAD_GO=true
OFFLOAD_CARGO=true
OFFLOAD_PLAYWRIGHT=true

# Local AI Models
OFFLOAD_AI_MODELS=true

# Prevent macOS Spotlight churn
PREVENT_SPOTLIGHT_INDEXING=true
```

---

## 🗄️ On-Demand Containerized Databases

Orbit-Disk includes a modular Docker Compose template for running on-demand databases stored completely on your external SSD:

```bash
cp docker-compose.example.yml /Volumes/External/dev-dbs/docker-compose.yml
cd /Volumes/External/dev-dbs
docker compose up -d postgres   # Spin up Postgres 15 without Mac background daemons
```

---

## ☕ Support Independent Open Source

Orbit-Disk is built and maintained by **[Nabiaz](https://github.com/mushfiqnabiaz)**, a Product Manager and builder passionate about creating developer tools that eliminate everyday friction.

If Orbit-Disk saved your internal SSD from suffocating, saved you from an expensive Apple hardware upgrade, or made your daily workflow smoother, consider buying me a coffee!

<p align="left">
  <a href="https://www.buymeacoffee.com/mushfiqnabiaz" target="_blank">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" width="180">
  </a>
</p>

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for more details.
