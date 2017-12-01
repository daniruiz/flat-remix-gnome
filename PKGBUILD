# Maintainer: Daniel Ruiz de Alegria <daniruizdealegria@gmail.com>

pkgname="flat-remix-gnome-git"
pkgver=20171129
pkgrel=1
pkgdesc="Flat Remix GNOME theme is a pretty simple shell theme inspired on material design."
arch=('any')
url="https://github.com/daniruiz/Flat-Remix-GNOME-theme/"
license=('CC-BY-SA-4.0')
source=("${pkgname}::git+https://github.com/daniruiz/Flat-Remix-GNOME-theme.git")
sha256sums=('SKIP')

pkgver() {
    cd "${pkgname}"
    git log -1 --format="%cd" --date=short | tr -d '-'
}

package() {
    cd "${srcdir}/${pkgname}/"
    install -dm755 "${pkgdir}/usr/share/themes"
    cp -a "Flat Remix"* "${pkgdir}/usr/share/themes/"
    install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}
