# Windows 7 Icon Theme for Linux

[![License: GPL-3.0-or-later](https://img.shields.io/badge/License-GPL%203.0+-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![GTK Compatibility](https://img.shields.io/badge/GTK-3%20%7C%204-green.svg)](https://www.gtk.org/)
[![Arch Linux PKGBUILD](https://img.shields.io/badge/Arch%20Linux-PKGBUILD-1793d1.svg)](PKGBUILD)

A high-fidelity, skeuomorphic **Windows 7 Aero** icon theme modernized and optimized for current Linux desktop environments (**XFCE**, **Cinnamon**, **MATE**, and **GNOME** / **GTK 3 & GTK 4**).

---

## Key Highlights & Improvements

This repository is an updated and optimized fork maintaining full compatibility with modern FreeDesktop and XDG standards:

- **FreeDesktop XDG Specification Compliance (`index.theme`)**:
  - Raster PNG directories are strictly reclassified as `Type=Fixed` and `Type=Threshold` (with `Threshold=2`), keeping `Type=Scalable` strictly for vector SVG icons.
  - Fixes icon scaling artifacts, blurry downscaling, and visual cutoffs in desktop panels and system trays (24px, 28px, 32px, 48px).
- **FreeDesktop Modern Naming & Symlinks**:
  - Full support for modern reverse-DNS application identifiers: `org.xfce.*` (Settings Manager, Thunar, Terminal Emulator, Screenshooter, Clipman, Taskmanager, Power Manager), `org.gnome.*` (Calculator, Loupe, FileRoller, gedit, SystemMonitor), `org.pulseaudio.pavucontrol`, and modern terminal emulators (`kitty`, `alacritty`).
  - Native `places/` directory structure matching modern file managers (Thunar 4.20+, Nemo, Nautilus, Caja, PCManFM).
- **Authentic Windows 7 Power & Lock Buttons**:
  - FreeDesktop session actions (`xfsm-logout`, `application-exit`, `system-shutdown`, `system-log-out`) are mapped to the authentic Windows 7 power orb (`boot.png`).
  - Lock actions (`xflock4`, `system-lock-screen`) are mapped to the Windows 7 lock icon.
- **Git & Packaging Integrity**:
  - Resolved upstream git blob mode issues on `apps/banshee.png`, `apps/banshee-panel.png`, and `apps/mozilla-firefox.png`.
  - Fixed filenames containing spaces to comply with `gtk-update-icon-cache` hashing requirements.
  - Cleaned up root directory layout while preserving custom Cinnamon applet assets in `applets/`.
- **Fast GTK Icon Cache**:
  - Fully compatible with `gtk-update-icon-cache` and `gtk4-update-icon-cache` for instant desktop loading with low memory overhead.

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

### Method 3: Manual Installation

1. Copy the theme directory to either user or system icon path:
   - User: `mkdir -p ~/.local/share/icons/Windows-7 && cp -dr . ~/.local/share/icons/Windows-7/`
   - System: `sudo cp -dr . /usr/share/icons/Windows-7/`
2. Update the GTK icon cache:
   ```bash
   gtk-update-icon-cache -f ~/.local/share/icons/Windows-7
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

## Credits & Upstream History

- **Win2-7 Pack**: Original concept and assets by [b00merang / Gnome-Look](https://www.gnome-look.org/content/show.php/Win2-7+Pack?content=113264).
- **Xopek-Endurance**: Upstream fork adding modern Cinnamon symbolic icons.
- **siliconfps**: Maintenance, FreeDesktop standards alignment, `index.theme` raster optimizations, XFCE / modern GTK fixes, installer, and Arch Linux packaging.
