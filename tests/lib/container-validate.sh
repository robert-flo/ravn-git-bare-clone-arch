#!/usr/bin/env bash

# Runs INSIDE the disposable archlinux:latest container started by
# validate-local-install.sh. Never run this on the host.
#
# Expects, mounted read-only by the caller:
#   /package                                        the ravn-git-bare-clone package sources (PKGBUILD, etc.)
#   /archive/ravn-git-bare-clone-${PKG_VERSION}.tar.gz  the local source snapshot
#
# Expects, from the environment:
#   PKG_VERSION                                     package version, matches the archive filename

set -Eeuo pipefail

phase_install_prereqs() {
  printf '\n==> [container 1/5] Refreshing Arch and installing exact prerequisites\n'
  printf '    These packages exist only inside this disposable container.\n\n'
  pacman -Syu --noconfirm --needed fakeroot sudo git github-cli jq
}

phase_create_builder_user() {
  printf '\n==> [container 2/5] Creating the unprivileged makepkg user\n'
  useradd --create-home builder
  printf 'builder ALL=(ALL) NOPASSWD: ALL\n' > /etc/sudoers.d/builder
  chmod 0440 /etc/sudoers.d/builder
}

phase_prepare_workspace() {
  printf '==> [container 3/5] Preparing the writable package workspace\n'
  install -d -m 0755 /work/package
  cp -a /package/. /work/package/

  # The checkout may contain ignored makepkg artifacts. They must not let this
  # validation install an older package instead of building the current PKGBUILD.
  find /work/package -maxdepth 1 -type f -name '*.pkg.tar.*' -delete

  # A local git archive has different bytes from the published GitHub archive.
  # Redirect PKGBUILD to it here; validate-release-archive.sh independently
  # checks the published checksums.
  sed -i \
    "s|\${url}/archive/refs/tags/v\${pkgver}.tar.gz|file:///archive/ravn-git-bare-clone-${PKG_VERSION}.tar.gz|" \
    /work/package/PKGBUILD

  chown -R builder:builder /work/package
}

phase_build_and_install() {
  printf '==> [container 4/5] Building and installing the local package\n'
  su --shell /bin/bash builder --command \
      'cd /work/package && makepkg -Cfi --noconfirm --needed --skipchecksums'
}

phase_verify_binaries_and_symlinks() {
  local bins=(
    "/usr/bin/ravn-git-bare-clone"
    "/usr/bin/git-bare-clone"
    "/usr/bin/git-create-worktree"
    "/usr/bin/git-issue-worktree"
  )

  for b in "${bins[@]}"; do
    test -e "$b"
    test -L "$b"
    test -x "$b"
  done

  test -x /opt/ravn-git-bare-clone/ravn-git-bare-clone
  test -x /opt/ravn-git-bare-clone/bin/git-bare-clone
  test -x /opt/ravn-git-bare-clone/bin/git-create-worktree
  test -x /opt/ravn-git-bare-clone/bin/git-issue-worktree
  test -f /opt/ravn-git-bare-clone/runtime/commands.tsv
  test -f /opt/ravn-git-bare-clone/runtime/lib/global_fn.sh
}

phase_exercise_public_commands() {
  printf '\n==> [container 5/5] Confirming the installed public commands behave as expected\n'
  phase_verify_binaries_and_symlinks

  /usr/bin/ravn-git-bare-clone help > /tmp/ravn-help.txt
  grep -Fq "ravn-git-bare-clone" /tmp/ravn-help.txt
  grep -Fq "clone" /tmp/ravn-help.txt
  grep -Fq "sync" /tmp/ravn-help.txt
  grep -Fq "create" /tmp/ravn-help.txt
  grep -Fq "issue" /tmp/ravn-help.txt

  /usr/bin/git-bare-clone --help > /tmp/clone-help.txt
  grep -Fq "ravn-git-bare-clone clone" /tmp/clone-help.txt

  /usr/bin/git-create-worktree --help > /tmp/create-help.txt
  grep -Fq "ravn-git-bare-clone create" /tmp/create-help.txt

  /usr/bin/git-issue-worktree --help > /tmp/issue-help.txt
  grep -Fq "ravn-git-bare-clone issue" /tmp/issue-help.txt

  printf '==> [container 5/5] PASS: all 4 public commands and payload verified\n'
}

main() {
  phase_install_prereqs
  phase_create_builder_user
  phase_prepare_workspace
  phase_build_and_install
  phase_exercise_public_commands
}

main "$@"
