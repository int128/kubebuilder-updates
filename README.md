# hello-kubebuilder

Hello world with kubebuilder.

```console
% go version
go version go1.19 darwin/arm64

% kubebuilder version
Version: main.version{KubeBuilderVersion:"3.6.0", KubernetesVendor:"unknown", GitCommit:"f20414648f1851ae97997f4a5f8eb4329f450f6d", BuildDate:"2022-08-03T09:01:53Z", GoOs:"darwin", GoArch:"arm64"}
```

```sh
kubebuilder init --domain int128.github.io --repo int128.github.io/hello-kubebuilder

kubebuilder create api --group webapp --version v1 --kind Guestbook
make manifests
```
