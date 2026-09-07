# Maintainer: siliconfps <https://github.com/siliconfps>

pkgname=windows-7-icon-theme-git
_pkgname=Windows-7
pkgver=r14.3a4ef5c
pkgrel=1
pkgdesc="Windows 7 icon theme for Linux desktops (GTK 3, GTK 4, XFCE, MATE, Cinnamon)"
arch=('any')
url="https://github.com/siliconfps/Windows-7"
license=('GPL-3.0-or-later')
depends=('gtk-update-icon-cache' 'hicolor-icon-theme')
makedepends=('git')
optdepends=('cinnamon: support for custom applet icons')
provides=('windows-7-icon-theme')
conflicts=('windows-7-icon-theme')
source=("git+https://github.com/siliconfps/Windows-7.git")
sha256sums=('SKIP')

pkgver() {
    cd "${srcdir}/${_pkgname}"
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short=7 HEAD)"
}

package() {
    cd "${srcdir}/${_pkgname}"

    local _dest="${pkgdir}/usr/share/icons/Windows-7"
    install -d "${_dest}"

    # Install icon theme tree excluding git, packaging, and scripts
    find . -mindepth 1 -maxdepth 1 \
        ! -name '.git*' \
        ! -name 'PKGBUILD' \
        ! -name 'install.sh' \
        ! -name 'applets' \
        ! -name 'llms.md' \
        ! -name '*.pkg.tar.*' \
        -exec cp -dr --no-preserve=ownership -t "${_dest}/" {} +
}
