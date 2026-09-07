# Windows 7 Icon Theme for Linux

[![Latest Release](https://img.shields.io/github/v/release/siliconfps/Windows-7?color=blue&label=Release)](https://github.com/siliconfps/Windows-7/releases/latest)
[![License: GPL-3.0-or-later](https://img.shields.io/badge/License-GPL%203.0+-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![GTK Compatibility](https://img.shields.io/badge/GTK-3%20%7C%204-green.svg)](https://www.gtk.org/)
[![Arch Linux PKGBUILD](https://img.shields.io/badge/Arch%20Linux-PKGBUILD-1793d1.svg)](PKGBUILD)

<p align="center">
  <img src="preview.png" alt="Windows 7 Icon Theme Preview" width="800" />
</p>

A high-fidelity, skeuomorphic **Windows 7 Aero** icon theme modernized and optimized for current Linux desktop environments (**XFCE**, **Cinnamon**, **MATE**, and **GNOME** / **GTK 3 & GTK 4**).

---

## Why Choose This Fork? (Comparison with Legacy Themes)

Most older Windows 7 icon packs on Gnome-Look / GitHub (like the original `Win2-7 Pack` and unmaintained mirrors) were designed for GTK 2 and broke on modern GTK 3 and GTK 4 desktops. This repository is an active, modernized fork resolving all known compatibility issues:

| Feature / Issue | Legacy Windows 7 Themes | siliconfps/Windows-7 (This Fork) |
| :--- | :--- | :--- |
| **GTK 3 & GTK 4 Scaling** | ❌ Raster PNGs marked as `Scalable` (causes blurry, oversized buttons and high CPU) | ✅ Raster directories correctly classified as `Type=Threshold` / `Fixed` (sharp downscaling to 16/24/32px) |
| **GTK Icon Cache** | ❌ Fails with `The generated cache was invalid` due to spaces in filenames | ✅ Compiles with **zero errors** via `gtk-update-icon-cache` |
| **Modern Places Context** | ❌ Missing `places/` directory (falls back to generic Adwaita/hicolor folder icons) | ✅ Native `places/` and `places/16/` support for Thunar 4.20+, Nemo, Nautilus |
| **App Identifiers** | ❌ Only legacy short names (`thunar`, `gedit`, `mousepad`) | ✅ Full modern reverse-DNS support (`org.xfce.*`, `org.gnome.*`, `pavucontrol`, `kitty`, `alacritty`) |
| **Power & Session Buttons** | ❌ Generic orange GNOME exit icon | ✅ Iconic Windows 7 red power orb (`boot.png`) for Whisker Menu and logout dialogs |
| **Automated Installer** | ❌ Manual file copying required | ✅ Fully featured `install.sh` supporting user-level, system-wide (`pkexec`), and Cinnamon applets |
| **Arch Linux Packaging** | ❌ None | ✅ Complete `PKGBUILD` for Arch Linux, CachyOS, Manjaro, and AUR |
| **AI Readability** | ❌ No structured metadata | ✅ Standard `llms.txt` and `llms.md` for AI search discovery and automated maintenance |

---

## Installation

### Method 1: Automated Script (`install.sh`)

Clone the repository and run the installer script:

```bash
git clone https://github.com/siliconfps/Windows-7.git
cd Windows-7
```

**For current user only (recommended, no root required):**
```bash
./install.sh --user
```
*Installs into `~/.local/share/icons/Windows-7` and builds the user icon cache.*

**System-wide installation (all users):**
```bash
./install.sh --system
```
*Installs into `/usr/share/icons/Windows-7`. Automatically requests graphical authentication via `pkexec`.*

**Optional: Install Cinnamon Applets Overrides:**
```bash
./install.sh --system --cinnamon-applets
```

---

### Method 2: Arch Linux (PKGBUILD / AUR)

Build and install directly using `makepkg`:

```bash
git clone https://github.com/siliconfps/Windows-7.git
cd Windows-7
makepkg -si
```

Pacman's ALPM hooks will automatically trigger `gtk-update-icon-cache` upon installation.

---

### Method 3: Pre-packaged Release Archives

Download the latest release archive (`.tar.xz` or `.tar.gz`) from the [Releases Page](https://github.com/siliconfps/Windows-7/releases/latest):

```bash
tar -xf Windows-7-v1.0.0.tar.xz
cd Windows-7
./install.sh --user
```

---

## Applying the Theme

After installation, activate the theme in your desktop environment's settings:

- **XFCE**: `Settings` → `Appearance` → `Icons` tab → Select **Windows-7**.
- **Cinnamon**: `System Settings` → `Themes` → `Icons` → Select **Windows-7**.
- **MATE**: `System` → `Preferences` → `Look and Feel` → `Appearance` → `Theme` → `Customize...` → `Icons` → Select **Windows-7**.
- **GNOME**: Use GNOME Tweaks → `Appearance` → `Icons` → Select **Windows-7**.

---

## Cinnamon Applets

Custom icons for native Cinnamon applets are provided in the `applets/` directory. See [`applets/APPLETS.md`](applets/APPLETS.md) for details on overrides for `notifications@cinnamon.org`, `grouped-window-list@cinnamon.org`, and others.

---

## Machine & AI Discovery

For AI assistants and search agents maintaining or indexing this repository:
- Summary metadata: [`llms.txt`](llms.txt) (following the llmstxt.org specification)
- Technical architecture and maintenance guide: [`llms.md`](llms.md)

---

## Credits & Upstream History

- **Win2-7 Pack**: Original concept and assets by [b00merang / Gnome-Look](https://www.gnome-look.org/content/show.php/Win2-7+Pack?content=113264).
- **Xopek-Endurance**: Upstream fork adding modern Cinnamon symbolic icons.
- **siliconfps**: Maintenance, FreeDesktop standards alignment, `index.theme` raster optimizations, XFCE / modern GTK fixes, installer, and Arch Linux packaging.
