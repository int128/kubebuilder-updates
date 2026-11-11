#!/bin/bash
set -eux -o pipefail

: "$IMAGE_URI"

kubebuilder_version="$(aqua which --version kubebuilder)"

perl -i "s/__IMAGE_URI__/$IMAGE_URI/" charts/chart/values.yaml

helm package charts/chart --app-version "$kubebuilder_version" --version "$kubebuilder_version"
helm push "kubebuilder-updates-${kubebuilder_version}.tgz" "oci://ghcr.io/$GITHUB_REPOSITORY/charts"
