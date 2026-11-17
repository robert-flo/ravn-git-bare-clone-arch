# Maintainer: Roberto Flores <25asab015@ujmd.edu.sv>

pkgname=ravn-git-bare-clone
pkgver=0.2.0
pkgrel=1
pkgdesc='Launcher y runtime modular de clonación bare y gestión de worktrees'
arch=('any')
url='https://github.com/robert-flo/ravn-git-bare-clone'
license=('MIT')
options=('!debug')
depends=('git' 'github-cli' 'jq')
source=(
  "${pkgname}-${pkgver}.tar.gz::${url}/archive/refs/tags/v${pkgver}.tar.gz"
)
sha256sums=(
  '37c5bbc7b29653c8ab9af51b4f56d86d523030f2d2e41a4f00028bded26f0854'
)

package() {
  cd "${srcdir}/${pkgname}-${pkgver}"
  make install DESTDIR="${pkgdir}" PREFIX="/opt/${pkgname}" BINDIR="/usr/bin"
}
