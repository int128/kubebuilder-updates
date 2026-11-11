#!/bin/bash
set -eux -o pipefail

: "$GITHUB_EVENT_NAME"
: "$IMAGE_URI"

# Set the default image
yq -i '.manager.image.repository = env(IMAGE_URI)' charts/chart/values.yaml

# Push the tag corresponding to the kubebuilder version.
# For a pull request, push 0.0.0 tag.
kubebuilder_version="$(aqua which --version kubebuilder)"
chart_version="${kubebuilder_version#v}"
if [[ $GITHUB_EVENT_NAME = pull_request ]]; then
  chart_version=0.0.0
fi

helm package charts/chart --app-version "$chart_version" --version "$chart_version"
helm push "kubebuilder-updates-${chart_version}.tgz" "oci://ghcr.io/$GITHUB_REPOSITORY/charts"
