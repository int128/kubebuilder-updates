#!/bin/bash
set -eux -o pipefail

: "${GITHUB_BASE_REF}"

# Download the newer Go version when go.mod is changed on kubebuilder init.
export GOTOOLCHAIN=auto

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

scaffold_helm_chart () {
  kustomize build config/default > /tmp/install.yaml
  kubebuilder edit --plugins=helm/v2-alpha --output-dir=charts --manifests=/tmp/install.yaml
}

scaffold_project
scaffold_helm_chart

# Restore the original files
rm -vfr .github
git checkout -- e2e_test .github
