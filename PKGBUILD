# Maintainer: Roberto Flores <25asab015@ujmd.edu.sv>

pkgname=ravn-git-bare-clone
pkgver=0.1.0
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
  'd8aa6532e86c6f06612e770ed6c321de4261b338fb79b06aebd41156a4353464'
)

package() {
  cd "${srcdir}/${pkgname}-${pkgver}"
  make install DESTDIR="${pkgdir}" PREFIX="/opt/${pkgname}" BINDIR="/usr/bin"
}
