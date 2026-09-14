# Changelog

All notable changes to the Windows-7 icon theme. Tag format `vX.Y.Z`.
Current stable: **v1.1.0** (Pling + GitHub).

## [v1.1.0] - 2026-09-14

Upgrade from v1.0.1. No new dependencies, no config wipe needed.

### Fixed
- Oversized icons on XFCE panels, toolbars and Whisker Menu: 18/22/24px
  requests no longer fall back to 128px art (17k-lookup battery:
  750 regressions → 0).
- Missing `folder-home` icons (4 tiers) and `system-reboot` icons (2 tiers).
- Corrupt `apps/user-desktop.png` replaced.
- `gtk-update-icon-cache: The generated cache was invalid` — filenames with
  spaces sanitized, cache builds with zero errors.
- Extensionless SVGs suffixed (e.g. `filesystems/user-home.svg`) with
  compatibility symlinks kept.

### Added
- Complete 16/24/32/48 tiers across actions, apps, categories, devices,
  mimetypes, places, status: 15 new tier dirs, ~1730 symlinks to
  nearest-below art + 161 pre-rendered exact-size PNGs.
- `places/` + `places/16/` coverage for Thunar 4.20+, Nemo, Nautilus
  (symlinked to canonical `filesystems/` set).
- Modern app IDs at every tier: `org.xfce.*`, `org.gnome.*`,
  `org.pulseaudio.pavucontrol`, `kitty`, `alacritty`.
- Aero red power orb (`boot.png` family) kept for logout/reboot/Whisker buttons.

### Installer & packaging
- `install.sh`: fixed pkexec re-exec (absolute path, no duplicated
  `--system`), added `--destdir` staging and `--uninstall`.
- `PKGBUILD`: license to `/usr/share/licenses`, never ships stale
  `icon-theme.cache`, cache rebuilt via Arch ALPM hooks.
- Housekeeping: strays relocated (`back1`/`forward1`, `window-*`,
  XFCE 48px → `apps/48`, `scalable/apps` PNGs → `apps/`), netstatus strips
  → `extras/archive/`.

### Artifacts
- `Windows-7-v1.1.0.tar.xz` (14 MB), `Windows-7-v1.1.0.tar.gz` (18 MB),
  `SHA256SUMS`. Archives extract to `Windows-7/` with `index.theme` at root:
  `tar -xf Windows-7-v1.1.0.tar.xz && cd Windows-7 && ./install.sh --user`.

## [v1.0.1] - 2026-09-12 (superseded)

Last v1.0.x baseline, kept for history:
- Wide-`Scalable` sizing policy for raster dirs (closest-Size wins, small
  requests get small art).
- Native `places/` support, reverse-DNS app symlinks, red power orb session icons.
- `install.sh` (--user / --system via pkexec), Arch `PKGBUILD`, `llms.txt` / `llms.md`.
- Zero-error `gtk-update-icon-cache` build.

[Full Pling-ready notes](dist/CHANGELOG-v1.1.0.txt).
License: GPL-3.0-or-later (`COPYING`).
