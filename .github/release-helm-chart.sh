#!/bin/bash
set -eux -o pipefail

: "$IMAGE_URI"

yq -i '.manager.image.repository = env(IMAGE_URI)' charts/chart/values.yaml

kubebuilder_version="$(aqua which --version kubebuilder)"
chart_version="${kubebuilder_version#v}"

helm package charts/chart --app-version "$chart_version" --version "$chart_version"
helm push "kubebuilder-updates-${chart_version}.tgz" "oci://ghcr.io/$GITHUB_REPOSITORY/charts"
