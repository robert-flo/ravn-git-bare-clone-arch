# ravn-git-bare-clone for Arch Linux

An Arch Linux installation package for
[ravn-git-bare-clone](https://github.com/robert-flo/ravn-git-bare-clone), built
with the same local PKGBUILD workflow used by AUR packages. Clone the package
repository, inspect or adjust PKGBUILD if needed, then build a Pacman package
on your machine.

Upstream project: [robert-flo/ravn-git-bare-clone.git](https://github.com/robert-flo/ravn-git-bare-clone.git)

The installed package provides the public commands at:
- `/usr/bin/ravn-git-bare-clone`
- `/usr/bin/git-bare-clone`
- `/usr/bin/git-create-worktree`
- `/usr/bin/git-issue-worktree`

It keeps the private implementation under `/opt/ravn-git-bare-clone`.

---

<br>

<a id="installation"></a>
<img src="https://readme-typing-svg.herokuapp.com?font=Lexend+Giga&size=25&pause=1000&color=CCA9DD&vCenter=true&width=435&height=25&lines=INSTALLATION" width="450"/>

### Build and Install Locally

Clone this package repository, then choose either installation workflow.

### Standard Arch / AUR-Style Workflow

```shell
git clone https://github.com/robert-flo/ravn-git-bare-clone-arch.git
cd ravn-git-bare-clone-arch
makepkg -si
```

This is the conventional workflow for a local PKGBUILD or an AUR package:
makepkg builds the Pacman package and -i installs it.

### Project Make Workflow

```shell
git clone https://github.com/robert-flo/ravn-git-bare-clone-arch.git
cd ravn-git-bare-clone-arch
make install
```

make install runs makepkg -si for you and adds the project's formatted status
messages and next-action guidance. Use one workflow or the other; do not run
make install followed by makepkg -si, because both perform the same package
build-and-install operation.

After installation, run `ravn-git-bare-clone help` or `git-bare-clone --help`.

The package downloads the tagged release archive pinned by PKGBUILD,
verifies its fixed SHA-256 checksum, and installs only the launcher plus the
release payload. It requires git, github-cli, and jq.

---

<br>

<a id="package-workflow"></a>
<img src="https://readme-typing-svg.herokuapp.com?font=Lexend+Giga&size=25&pause=1000&color=CCA9DD&vCenter=true&width=435&height=25&lines=PACKAGE%20WORKFLOW" width="450"/>

The repository wraps the usual package-maintenance tasks in make targets:

```shell
make build       # makepkg -s: build without installing
make install     # makepkg -si: build or reuse, then install
make reinstall   # makepkg -Cfi: force a clean rebuild and installation
make clean       # remove src/, pkg/, downloaded archives, and package artifacts
make lint        # check Bash, ShellCheck, .SRCINFO, and whitespace
```

Run make reinstall after changing PKGBUILD or when a package artifact from an
earlier build is present. Run make clean when you want a completely clean
checkout for a fresh package build.

Use make help for the complete, interactive list.

---

<br>

<a id="validation"></a>
<img src="https://readme-typing-svg.herokuapp.com?font=Lexend+Giga&size=25&pause=1000&color=CCA9DD&vCenter=true&width=435&height=25&lines=VALIDATION" width="450"/>

The package has two deliberately separate Docker validations. Both use
docker run --rm; neither installs or upgrades host packages, mounts the host
home directory, Git configuration, SSH keys, GPG keys, or package cache.

```shell
make test-release
make test-local SOURCE_DIR=/path/to/ravn-git-bare-clone
make test SOURCE_DIR=/path/to/ravn-git-bare-clone
```

SOURCE_DIR is equivalent to RAVN_GIT_BARE_CLONE_SOURCE_DIR. It must identify a Git
worktree containing the source repository's root ravn-git-bare-clone launcher.

### Published Release Archive

make test-release checks release integrity only. Inside a disposable
archlinux:latest container it rejects SKIP or malformed archive checksums,
downloads every PKGBUILD source entry, and runs makepkg --verifysource.

### Local Package Installation

make test-local SOURCE_DIR=... validates an actual committed source revision.
It creates a temporary archive from git archive HEAD, redirects PKGBUILD to
that local archive, builds and installs the package in a disposable Arch
container, and exercises the installed public commands.

Inside the disposable container, the local validation installs:

```shell
fakeroot sudo git github-cli jq
```

---

<br>

<a id="repository-roles"></a>
<img src="https://readme-typing-svg.herokuapp.com?font=Lexend+Giga&size=25&pause=1000&color=CCA9DD&vCenter=true&width=435&height=25&lines=REPOSITORY%20ROLES" width="450"/>

The source repository contains the launcher and modules, and publishes version
tags. This repository contains the Arch PKGBUILD and package validations.

### Automated Upstream Updates

GitHub Actions checks the latest stable release from the source repository once
per day and can also be run manually. When either the release version or its
generated source-archive checksum changes, the workflow updates PKGBUILD,
regenerates .SRCINFO, builds the package as a non-root user, uploads the package
artifact, and commits the verified metadata back to this repository.

The offline contract test is available locally with:

```shell
make test-automation
```

---

<br>

## License

The packaged source is released under the
[source project's MIT License](https://github.com/robert-flo/ravn-git-bare-clone/blob/main/LICENSE).
