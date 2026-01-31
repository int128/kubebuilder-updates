#!/bin/bash
set -eux -o pipefail

: "${GITHUB_BASE_REF}"

# Download the newer Go version when go.mod is changed on kubebuilder init.
export GOTOOLCHAIN=auto

install_kubebuilder () {
  local kubebuilder_version="$(cat .kubebuilder-version)"
  curl -sfL -o kubebuilder "https://github.com/kubernetes-sigs/kubebuilder/releases/download/${kubebuilder_version}/kubebuilder_$(go env GOOS)_$(go env GOARCH)"
  chmod +x kubebuilder
  mv kubebuilder /usr/local/bin/
  kubebuilder version
}

scaffold_project () {
  # Remove the existing files to avoid kubebuilder error
  rm -vfr \
    PROJECT \
    api \
    cmd \
    config \
    internal \
    bin \
    hack \
    test \
    e2e_test \
    Makefile \
    Dockerfile \
    .golangci.yml \
    .*ignore \
    go.*

  kubebuilder init --domain int128.github.io --repo int128.github.io/kubebuilder-updates
  kubebuilder create api --group webapp --version v1 --kind Guestbook --controller --resource

  go version
  make generate manifests
}

install_kubebuilder
scaffold_project

# Restore the original files
rm -vfr .github
git checkout -- e2e_test .github
