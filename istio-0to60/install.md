A Kubernetes cluster was provisioned on your behalf.

Verify that `kubectl` is configured:

```
k get ns
```{{exec}}

## Install Istio

You will be using Istio version 1.14.0:

```
export ISTIO_VERSION=1.14.0
```{{exec}}

Download the Istio distribution:

```
curl -L https://istio.io/downloadIstio | TARGET_ARCH=x86_64 sh -
```{{exec}}

Configure the Istio CLI (istioctl):

```
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

_The contents of the file `install-manifest.yaml` represent tweaks to the default profile configuration to accommodate the environment in which this lab is running._

Verify that Istio is installed in your cluster:

1. Re-run `istioctl version` and notice how the output differs from the previous run.
1. Note a new Kubernetes namespace `istio-system`, also known as the Istio _root namespace_:

    ```
    k get ns
    ```{{exec}}

1. Review the deployments and services in the `istio-system` namespace

    ```
    k get deploy -n istio-system
    ```{{exec}}

    ```
    k get svc -n istio-system
    ```{{exec}}

## Next

With Istio installed, we are ready to deploy an application to the mesh.
