#!/bin/bash
set -eux -o pipefail

: "${GITHUB_BASE_REF}"

git fetch origin --depth=1 "${GITHUB_BASE_REF}:${GITHUB_BASE_REF}"
kubebuilder_version="$(cat .kubebuilder-version)"

# Install kubebuilder
curl -sfL -o kubebuilder "https://github.com/kubernetes-sigs/kubebuilder/releases/download/${kubebuilder_version}/kubebuilder_$(go env GOOS)_$(go env GOARCH)"
chmod +x kubebuilder
mv kubebuilder /usr/local/bin/
go version
kubebuilder version

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

# Scaffold the project
kubebuilder init --domain int128.github.io --repo int128.github.io/kubebuilder-updates
kubebuilder create api --group webapp --version v1 --kind Guestbook --controller --resource
make test

# Restore the original files
rm -vfr .github
git checkout -- e2e_test .github
