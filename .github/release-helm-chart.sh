#!/bin/bash
set -eux -o pipefail

: "$IMAGE_URI"

yq -i '.manager.image.repository = env(IMAGE_URI)' charts/chart/values.yaml

kubebuilder_version="$(aqua which --version kubebuilder)"

helm package charts/chart --app-version "$kubebuilder_version" --version "$kubebuilder_version"
helm push "kubebuilder-updates-${kubebuilder_version}.tgz" "oci://ghcr.io/$GITHUB_REPOSITORY/charts"
