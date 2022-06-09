A Kubernetes cluster was provisioned on your behalf.

Verify that `kubectl` is configured:

```
k get ns
```{{exec}}

## Install Istio

Download the Istio distribution:

```
curl -L https://istio.io/downloadIstio | TARGET_ARCH=x86_64 sh -
```{{exec}}

Configure the Istio CLI (istioctl):

```
export ISTIO_VERSION=1.14.0
export PATH=/root/istio-${ISTIO_VERSION}/bin:$PATH
```{{exec}}

For good measure, add the above PATH update to your `.bashrc` file:

```
echo "export PATH=/root/istio-${ISTIO_VERSION}/bin:\$PATH" >> .bashrc
```{{exec}}

Verify that the CLI is functioning:

```
istioctl version
```{{exec}}

Install Istio onto your Kubernetes cluster:

```
istioctl install -f install-manifest.yaml
```{{exec}}

** Some tweaks to the default profile configuration were made to accommodate the environment in which this lab is running.

Verify that istio is installed in your cluster:

1. Re-run `istioctl version`
1. Notice a new namespace named `istio-system`:

    ```
    k get ns
    ```{{exec}}
