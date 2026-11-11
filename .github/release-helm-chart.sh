#!/bin/bash
set -eux -o pipefail

kubebuilder_version="$(aqua which --version kubebuilder)"

helm package charts/chart --app-version "$kubebuilder_version" --version "$kubebuilder_version"
helm push chart-*.tgz "oci://ghcr.io/$GITHUB_REPOSITORY"
