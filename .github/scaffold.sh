#!/bin/bash
set -eux -o pipefail

: "${PULL_NUMBER}"
: "${GITHUB_BASE_REF}"

git fetch origin --depth=1 "${GITHUB_BASE_REF}:${GITHUB_BASE_REF}"
old_version="$(git show "${GITHUB_BASE_REF}:.kubebuilder-version")"
new_version="$(cat .kubebuilder-version)"

# Install kubebuilder
curl -sfL -o kubebuilder "https://github.com/kubernetes-sigs/kubebuilder/releases/download/${new_version}/kubebuilder_$(go env GOOS)_$(go env GOARCH)"
chmod +x kubebuilder
mv kubebuilder /usr/local/bin/

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
go version
kubebuilder version
kubebuilder init --domain int128.github.io --repo int128.github.io/kubebuilder-updates
kubebuilder create api --group webapp --version v1 --kind Guestbook --controller --resource

# Restore the original files
rm -vfr .github
git checkout -- e2e_test .github

# Commit the changes
git config user.name kubebuilder-updates
git config user.email 41898282+github-actions[bot]@users.noreply.github.com
git add .
git commit -m "Update kubebuilder from ${old_version} to ${new_version}"

head_sha="$(git rev-parse HEAD)"

# Generate the section
cat >> README.md <<EOF

### Update kubebuilder from ${old_version} to ${new_version}

To apply the patch of https://github.com/int128/kubebuilder-updates/pull/${PULL_NUMBER}/commits/${head_sha},

\`\`\`sh
# Fetch the diff
git fetch https://github.com/int128/kubebuilder-updates ${head_sha}

# Apply the patch
git checkout -b update-kubebuilder-${new_version}
git cherry-pick ${head_sha}
\`\`\`

You may need to resolve conflicts.

\`\`\`sh
git commit -m 'Update kubebuilder from ${old_version} to ${new_version}'
gh pr create -f
\`\`\`

EOF
