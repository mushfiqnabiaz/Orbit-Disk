#!/usr/bin/env python3
import time
import sys

CYAN = "\033[36m"
BRIGHT_CYAN = "\033[1;36m"
GREEN = "\033[32m"
BRIGHT_GREEN = "\033[1;32m"
YELLOW = "\033[1;33m"
PURPLE = "\033[1;35m"
WHITE = "\033[1;37m"
DIM = "\033[2m"
BOLD = "\033[1m"
RESET = "\033[0m"

BANNER_INSTALL = r"""   ____       __    _ __        ____  _     __  
  / __ \_____/ /_  (_) /_      / __ \(_)___/ /__
 / / / / ___/ __ \/ / __/_____/ / / / / ___/ //_/
/ /_/ / /  / /_/ / / /_/_____/ /_/ / (__  ) ,<   
\____/_/  /_.___/_/\__/     /_____/_/____/_/|_|  
                                                 
   Satellite Storage for macOS Developers (v1.1.0)"""

BANNER_STATUS = r"""   ____       __    _ __        ____  _     __  
  / __ \_____/ /_  (_) /_      / __ \(_)___/ /__
 / / / / ___/ __ \/ / __/_____/ / / / / ___/ //_/
/ /_/ / /  / /_/ / / /_/_____/ /_/ / (__  ) ,<   
\____/_/  /_.___/_/\__/     /_____/_/____/_/|_|  
                                                 
   Satellite Storage for macOS Developers (v1.1.0)"""

def clear():
    sys.stdout.write("\033[2J\033[H\033[3J")
    sys.stdout.flush()

def type_cmd(text, delay=0.045):
    sys.stdout.write(f"{BRIGHT_GREEN}➜{RESET} {BRIGHT_CYAN}~{RESET} ")
    sys.stdout.flush()
    time.sleep(0.35)
    for char in text:
        sys.stdout.write(char)
        sys.stdout.flush()
        time.sleep(delay)
    time.sleep(0.45)
    sys.stdout.write("\n")
    sys.stdout.flush()

def banner(step, text):
    print(f"\n{YELLOW}# Step {step}: {text}{RESET}")
    time.sleep(0.45)

def main():
    clear()
    time.sleep(0.5)

    # Step 1: Install
    banner("1", "Install Orbit-Disk with a single command")
    type_cmd("curl -fsSL https://raw.githubusercontent.com/mushfiqnabiaz/orbit-disk/main/install.sh | bash")
    time.sleep(0.35)
    print(f"{BRIGHT_CYAN}🛰️  Installing Orbit-Disk...{RESET}")
    time.sleep(0.45)
    print("Cloning into '/Users/developer/.orbit-disk'...")
    time.sleep(0.5)
    print(f"{BRIGHT_GREEN}✅ Added Orbit-Disk hook to ~/.zshrc{RESET}")
    time.sleep(0.4)
    print(f"\n{PURPLE}{BANNER_INSTALL}{RESET}\n")
    time.sleep(0.4)
    print("🔍 Scanning for connected external drives...")
    print(f"   [1] {BOLD}/Volumes/External{RESET} (156Gi free)")
    time.sleep(0.35)
    print(f"Select target drive [1-1] (Enter for [1]): {WHITE}1{RESET}")
    time.sleep(0.4)
    print("Saving settings to ~/.orbit-disk.conf...")
    print(f"{BRIGHT_GREEN}✅ Successfully docked Orbit-Disk to: /Volumes/External{RESET}")
    print(f"{BOLD}🎉 Orbit-Disk has been successfully installed!{RESET}")
    time.sleep(2.4)

    # Step 2: Status
    clear()
    banner("2", "Check satellite drive docking & offload status")
    type_cmd("orbit status")
    time.sleep(0.3)
    print(f"{PURPLE}{BANNER_STATUS}{RESET}\n")
    print("⚙️  Configuration: ~/.orbit-disk.conf")
    print(f"{BRIGHT_GREEN}🟢 Drive Status:   DOCKED (In Orbit){RESET}")
    print("📍 Target Volume:  /Volumes/External")
    print("💾 Available:      156Gi (33% used)\n")
    print(f"{BOLD}📦 Offloaded Cache Paths:{RESET}")
    print(f"   • {BRIGHT_CYAN}XDG Cache:{RESET}     /Volumes/External/.cache")
    print(f"   • {BRIGHT_CYAN}Homebrew:{RESET}      /Volumes/External/Caches/Homebrew")
    print(f"   • {BRIGHT_CYAN}NPM Cache:{RESET}     /Volumes/External/.npm-cache")
    print(f"   • {BRIGHT_CYAN}PNPM Store:{RESET}    /Volumes/External/.pnpm")
    print(f"   • {BRIGHT_CYAN}Bun Cache:{RESET}     /Volumes/External/.bun-cache")
    print(f"   • {YELLOW}Android AVD:{RESET}   /Volumes/External/.android/avd")
    print(f"   • {YELLOW}Gradle Home:{RESET}   /Volumes/External/.gradle")
    print(f"   • {BRIGHT_CYAN}Go Build:{RESET}      /Volumes/External/Caches/go-build")
    print(f"   • {BRIGHT_CYAN}Rust Cargo:{RESET}    /Volumes/External/.cargo")
    print(f"   • {BRIGHT_CYAN}Playwright:{RESET}    /Volumes/External/Caches/ms-playwright")
    print(f"   • {PURPLE}AI (Ollama/HF):{RESET}/Volumes/External/ollama/models & /Volumes/External/.cache/huggingface\n")
    print(f"{BRIGHT_GREEN}🛡️  Spotlight Guard: Active (caches, emulators & DBs excluded from search churn){RESET}\n")
    time.sleep(3.2)

    # Step 3: Sweep
    banner("3", "Sweep temporary fallback caches into orbit")
    type_cmd("orbit sweep")
    time.sleep(0.3)
    print("🧹 Sweeping internal fallback caches into orbit (/Volumes/External)...")
    time.sleep(0.5)
    print(f"""📦 Shifted the following caches from internal drive to external SSD:
   • {BRIGHT_CYAN}.cache{RESET} (4.8 GB)
   • {BRIGHT_CYAN}.pnpm-store{RESET} (8.3 GB)
   • {BRIGHT_CYAN}go-build{RESET} (920 MB)""")
    print(f"{BRIGHT_GREEN}✅ Successfully swept 3 cache item(s)!{RESET}")
    print("✨ Internal drive is already clean. Nothing left to sweep.")
    time.sleep(2.8)

    # Step 4: Install App
    banner("4", "Install heavy apps directly to external drive & auto-link to /Applications")
    type_cmd("orbit install-app bruno")
    time.sleep(0.3)
    print("📦 Installing bruno to /Volumes/External via Homebrew...")
    time.sleep(0.6)
    print(f"{BRIGHT_GREEN}==> Downloading bruno...{RESET}")
    print(f"{BRIGHT_GREEN}==> Pouring bruno to /Volumes/External/Bruno.app{RESET}")
    print("🔗 Auto-linking to /Applications...")
    print(f"{BRIGHT_GREEN}✅ Linked Bruno.app into /Applications{RESET}")
    print(f"{BOLD}✅ Successfully installed and linked!{RESET}")
    time.sleep(2.8)

    # Step 5: Clean
    banner("5", "Clean project build caches in one command")
    type_cmd("orbit clean-next")
    time.sleep(0.3)
    print("🧹 Removing all .next build caches in current directory tree...")
    time.sleep(0.4)
    print(f"{BRIGHT_GREEN}✅ Cleaned all .next build caches.{RESET}")
    time.sleep(2.4)

if __name__ == "__main__":
    main()
