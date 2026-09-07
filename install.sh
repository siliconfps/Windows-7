#!/usr/bin/env bash
# ==============================================================================
# Windows-7 Icon Theme Installer
# Supports user-level (~/.local/share/icons) and system-wide (/usr/share/icons)
# Automatically builds GTK icon cache.
# ==============================================================================

set -euo pipefail

THEME_NAME="Windows-7"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ANSI color codes
CLR_RESET="\033[0m"
CLR_BOLD="\033[1m"
CLR_GREEN="\033[32m"
CLR_BLUE="\033[34m"
CLR_YELLOW="\033[33m"
CLR_RED="\033[31m"
CLR_CYAN="\033[36m"

print_info() {
    printf "${CLR_CYAN}::${CLR_RESET} ${CLR_BOLD}%s${CLR_RESET}\n" "$1"
}

print_success() {
    printf "${CLR_GREEN}==>${CLR_RESET} ${CLR_BOLD}%s${CLR_RESET}\n" "$1"
}

print_warn() {
    printf "${CLR_YELLOW}==> WARNING:${CLR_RESET} %s\n" "$1"
}

print_error() {
    printf "${CLR_RED}==> ERROR:${CLR_RESET} %s\n" "$1" >&2
}

show_help() {
    cat <<EOHELP
Usage: $(basename "$0") [OPTIONS]

Options:
  -u, --user            Install theme for current user only
                        (Target: \${XDG_DATA_HOME:-\$HOME/.local/share}/icons/${THEME_NAME})
  -s, --system          Install theme system-wide (requires root / pkexec)
                        (Target: /usr/share/icons/${THEME_NAME})
  -d, --destdir <DIR>   Install into custom staging directory
  --cinnamon-applets    Install custom Cinnamon applet icons into /usr/share/cinnamon/applets/
  -h, --help            Show this help message and exit

If no option is provided, the script automatically defaults to:
  - System-wide install if run as root
  - User-level install if run as a regular user
EOHELP
}

TARGET_MODE=""
CUSTOM_DESTDIR=""
INSTALL_APPLETS=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -u|--user)
            TARGET_MODE="user"
            shift
            ;;
        -s|--system)
            TARGET_MODE="system"
            shift
            ;;
        -d|--destdir)
            if [[ -n "${2:-}" ]]; then
                CUSTOM_DESTDIR="$2"
                shift 2
            else
                print_error "--destdir requires an argument."
                exit 1
            fi
            ;;
        --cinnamon-applets)
            INSTALL_APPLETS=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown argument: $1"
            show_help
            exit 1
            ;;
    esac
done

# Determine target directory
if [[ -n "$CUSTOM_DESTDIR" ]]; then
    TARGET_DIR="${CUSTOM_DESTDIR}/${THEME_NAME}"
elif [[ "$TARGET_MODE" == "user" ]]; then
    DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
    TARGET_DIR="${DATA_HOME}/icons/${THEME_NAME}"
elif [[ "$TARGET_MODE" == "system" ]]; then
    TARGET_DIR="/usr/share/icons/${THEME_NAME}"
else
    # Auto-detect mode
    if [[ $EUID -eq 0 ]]; then
        TARGET_MODE="system"
        TARGET_DIR="/usr/share/icons/${THEME_NAME}"
    else
        TARGET_MODE="user"
        DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
        TARGET_DIR="${DATA_HOME}/icons/${THEME_NAME}"
    fi
fi

# Elevation check for system-wide install
if [[ "$TARGET_MODE" == "system" && -z "$CUSTOM_DESTDIR" && $EUID -ne 0 ]]; then
    print_info "System-wide installation requires elevated privileges."
    print_info "Requesting authorization via pkexec..."
    
    # Strictly use pkexec (never raw sudo)
    if command -v pkexec >/dev/null 2>&1; then
        exec pkexec env DISPLAY="${DISPLAY:-}" XAUTHORITY="${XAUTHORITY:-}" "$0" --system "$@"
    else
        print_error "pkexec is required for graphical privilege elevation but was not found."
        exit 1
    fi
fi

print_info "Installing ${THEME_NAME} icon theme to: ${TARGET_DIR}"

mkdir -p "$TARGET_DIR"

# Copy icon theme tree excluding git, packaging, and scripts
EXCLUDE_LIST=(
    ".git"
    ".gitignore"
    "PKGBUILD"
    "install.sh"
    "icon-theme.cache"
    ".icon-theme.cache"
    "applets"
    "llms.md"
)

# Use cp or rsync if available
if command -v rsync >/dev/null 2>&1; then
    RSYNC_EXCLUDES=()
    for item in "${EXCLUDE_LIST[@]}"; do
        RSYNC_EXCLUDES+=("--exclude=${item}")
    done
    rsync -a --delete "${RSYNC_EXCLUDES[@]}" "${SCRIPT_DIR}/" "${TARGET_DIR}/"
else
    # Fallback to tar pipe
    TAR_EXCLUDES=()
    for item in "${EXCLUDE_LIST[@]}"; do
        TAR_EXCLUDES+=("--exclude=${item}")
    done
    tar -C "${SCRIPT_DIR}" "${TAR_EXCLUDES[@]}" -cf - . | tar -C "${TARGET_DIR}" -xf -
fi

print_success "Theme files successfully copied."

# Compile GTK Icon Cache
print_info "Generating GTK icon cache..."
CACHE_TOOL=""
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    CACHE_TOOL="gtk-update-icon-cache"
elif command -v gtk4-update-icon-cache >/dev/null 2>&1; then
    CACHE_TOOL="gtk4-update-icon-cache"
fi

if [[ -n "$CACHE_TOOL" ]]; then
    if "$CACHE_TOOL" -f -q -t "$TARGET_DIR"; then
        print_success "Icon cache generated successfully (${CACHE_TOOL})."
    else
        print_warn "Cache generation returned a non-zero code. Trying non-quiet mode..."
        "$CACHE_TOOL" -f "$TARGET_DIR" || print_warn "Could not build cache. The theme may still work, but with slower lookup."
    fi
else
    print_warn "Neither gtk-update-icon-cache nor gtk4-update-icon-cache was found. Cache was not compiled."
fi

# Optional Cinnamon Applets Installation
if [[ "$INSTALL_APPLETS" == true ]]; then
    if [[ -d "${SCRIPT_DIR}/applets" ]]; then
        print_info "Installing Cinnamon applet overrides to /usr/share/cinnamon/applets/..."
        if [[ $EUID -ne 0 ]]; then
            print_error "Cinnamon applets installation requires root privileges."
        else
            cp -rf "${SCRIPT_DIR}/applets/"*@cinnamon.org /usr/share/cinnamon/applets/ 2>/dev/null || print_warn "Could not copy all applet icons."
            print_success "Cinnamon applet icons installed."
        fi
    fi
fi

print_success "Installation complete!"
print_info "You can now select '${THEME_NAME}' in your desktop settings (XFCE Appearance, Cinnamon Themes, MATE Appearance, etc.)."
