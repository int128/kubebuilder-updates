#!/bin/bash
set -eux -o pipefail

: "${GITHUB_EVENT_NAME}"

kubebuilder_version="$(cat .kubebuilder-version)"

if gh release view "$kubebuilder_version"; then
  exit
fi

if [[ $GITHUB_EVENT_NAME == push ]]; then
  gh release create "$kubebuilder_version" --generate-notes
fi
