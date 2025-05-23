#!/bin/bash
set -eux -o pipefail

: "${GITHUB_REF}" # refs/pull/N/merge
: "${GITHUB_BASE_REF}"
: "${GITHUB_HEAD_REF}"

head_version="$(cat .kubebuilder-version)"

git fetch origin --depth=1 "${GITHUB_BASE_REF}:${GITHUB_BASE_REF}"
base_version="$(git show "${GITHUB_BASE_REF}:.kubebuilder-version")"

exit_if_readme_is_up_to_date () {
  if grep "<!-- kubebuilder ${head_version} -->" README.md; then
    echo "README is already up-to-date"
    exit 0
  fi
}

generate_readme () {
  git fetch origin --depth=10 "${GITHUB_HEAD_REF}:${GITHUB_HEAD_REF}"
  local scaffold_commit_sha="$(git log -1 --grep 'Generated by GitHub Actions (scaffold / project)' --format=%H "${GITHUB_BASE_REF}...${GITHUB_HEAD_REF}")"
  if [ -z "${scaffold_commit_sha}" ]; then
    echo "Commit not found"
    exit 1
  fi

  local pull_number="$(echo "${GITHUB_REF}" | cut -d/ -f3)"
  export README_SECTION="
<!-- kubebuilder ${head_version} -->
### Update kubebuilder from ${base_version} to ${head_version}

To apply the patch of https://github.com/int128/kubebuilder-updates/pull/${pull_number}/commits/${scaffold_commit_sha},

\`\`\`sh
# Fetch the diff
git fetch https://github.com/int128/kubebuilder-updates ${scaffold_commit_sha}

# Apply the patch
git checkout -b update-kubebuilder-${head_version}
git cherry-pick ${scaffold_commit_sha}
\`\`\`

You may need to resolve conflicts.

\`\`\`sh
git commit -m 'Update kubebuilder from ${base_version} to ${head_version}'
gh pr create -f
\`\`\`
"

  perl -i -ne 'print; if ($_ =~ /<!-- SECTION -->/) { print $ENV{"README_SECTION"} }' README.md
  unset README_SECTION
}

exit_if_readme_is_up_to_date
generate_readme
