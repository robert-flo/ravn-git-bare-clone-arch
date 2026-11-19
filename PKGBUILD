# Maintainer: Roberto Flores <25asab015@ujmd.edu.sv>

pkgname=ravn-git-bare-clone
pkgver=0.3.0
pkgrel=1
pkgdesc='Launcher y runtime modular de clonación bare y gestión de worktrees'
arch=('any')
url='https://github.com/robert-flo/ravn-git-bare-clone'
license=('MIT')
options=('!debug')
depends=('bash' 'git' 'github-cli' 'jq')
makedepends=('make')
source=("${pkgname}-${pkgver}.tar.gz::${url}/archive/refs/tags/v${pkgver}.tar.gz")
sha256sums=(
  'd21fd3c4ceb50a62a0e81ee58f0120c0b71a685e97354ed61cd99109a616ea38'
)

package() {
  local source_dir="${srcdir}/${pkgname}-${pkgver}"

  make -C "${source_dir}" DESTDIR="${pkgdir}" PREFIX="/opt/ravn-wt" BINDIR="/usr/bin" install
  install -Dm644 "${source_dir}/LICENSE" "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
  install -d "${pkgdir}/usr/share/bash-completion/completions"
  ln -s /opt/ravn-wt/runtime/completion/git-bare-clone.bash \
    "${pkgdir}/usr/share/bash-completion/completions/ravn-wt"
  ln -s /opt/ravn-wt/runtime/completion/git-bare-clone.bash \
    "${pkgdir}/usr/share/bash-completion/completions/ravn-git-bare-clone"
  ln -s /opt/ravn-wt/runtime/completion/git-bare-clone.bash \
    "${pkgdir}/usr/share/bash-completion/completions/git-bare-clone"
  install -d "${pkgdir}/usr/share/zsh/site-functions"
  ln -s /opt/ravn-wt/runtime/completion/_git-bare-clone \
    "${pkgdir}/usr/share/zsh/site-functions/_ravn-wt"
  ln -s /opt/ravn-wt/runtime/completion/_git-bare-clone \
    "${pkgdir}/usr/share/zsh/site-functions/_ravn-git-bare-clone"
  ln -s /opt/ravn-wt/runtime/completion/_git-bare-clone \
    "${pkgdir}/usr/share/zsh/site-functions/_git-bare-clone"
}
