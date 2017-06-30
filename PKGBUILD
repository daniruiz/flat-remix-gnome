# Maintainer:  DяA <daniruizdealegria@gmail.com>

pkgname=flat-remix-gnome-theme
pkgver=r54.b7a4014
pkgrel=1
pkgdesc="Flat Remix GNOME theme is a pretty simple shell theme inspired on material design"
arch=('any')
url="https://github.com/daniruiz/Flat-Remix-GNOME-theme/"
license=('CC-BY-SA-4.0')
depends=('gnome-shell')

source=("${pkgname}::git+https://github.com/daniruiz/Flat-Remix-GNOME-theme.git")

sha256sums=('SKIP')

pkgver() {
	cd "${pkgname}"
	printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
	cd "${srcdir}/${pkgname}/"
	install -dm755 "${pkgdir}/usr/share/themes"
	cp -a "Flat Remix" "${pkgdir}/usr/share/themes/Flat Remix"
	install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}
