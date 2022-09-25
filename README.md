# hello-kubebuilder [![scaffold](https://github.com/int128/hello-kubebuilder/actions/workflows/scaffold.yaml/badge.svg)](https://github.com/int128/hello-kubebuilder/actions/workflows/scaffold.yaml)

This repository contains scaffold with the following versions of kubebuilder.

- kubebuilder v3.7.0
- kubebuilder v3.6.0
- kubebuilder v3.5.0

## Upgrade from kubebuilder v3.6.0 to v3.7.0

See the diff from https://github.com/int128/hello-kubebuilder/pull/6/commits/15afba8bb4201076ea09a4761b1525185fa4ede0

To apply the patch to your repository,

```sh
# fetch the diff
git fetch https://github.com/int128/hello-kubebuilder 15afba8bb4201076ea09a4761b1525185fa4ede0

# apply the patch
git checkout -b upgrade-kubebuilder-v3.7.0
git cherry-pick 15afba8bb4201076ea09a4761b1525185fa4ede0
```

You need to resolve the conflicts.

### Ginkgo v2

You need to replace `github.com/onsi/ginkgo` with `github.com/onsi/ginkgo/v2`.
Run `go mod tidy` and make sure all imports have been replaced.

### Resource labels

Since v3.7.0, the metadata labels are added to all resources.
This patch contains an example name, so you need to replace `hello-kubebuilder` with your repository name.

```yaml
    app.kubernetes.io/created-by: hello-kubebuilder
    app.kubernetes.io/part-of: hello-kubebuilder
    app.kubernetes.io/managed-by: kustomize
```

## Upgrade from kubebuilder v3.5.0 to v3.6.0

See the diff from https://github.com/int128/hello-kubebuilder/pull/4/commits/e7921bbe47a5c309811c13441905af24b4a86dbe

To apply the patch to your repository,

```sh
# fetch the diff
git fetch https://github.com/int128/hello-kubebuilder e7921bbe47a5c309811c13441905af24b4a86dbe

# apply the patch
git checkout -b upgrade-kubebuilder-v3.6.0
git cherry-pick e7921bbe47a5c309811c13441905af24b4a86dbe
```
