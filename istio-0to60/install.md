A Kubernetes cluster was provisioned on your behalf.

Verify that `kubectl` is configured:

```
k get ns
```{{exec}}

## Install Istio

You will be using Istio version 1.14.3:

```
export ISTIO_VERSION=1.14.3
```{{exec}}

Download the Istio distribution:

```
curl -L https://istio.io/downloadIstio | TARGET_ARCH=x86_64 sh -
```{{exec}}

Note the istio distribution folder `istio-1.14.3` in your home directory:

```
ls -lF
```{{exec}}

The Istio CLI, `istioctl` is located in the distribution's `bin` directory.

Place `istioctl` in your `$PATH`:

```
cp istio-1.14.3/bin/istioctl /usr/local/bin
```{{exec}}

Verify that the CLI is functioning:

```
istioctl version
```{{exec}}

Note how the output of the above command states in so many words that Istio is not yet installed in your Kubernetes cluster, but that the client version is 1.14.3.

The file `install-manifest.yaml` is a configuration of Istio that tweaks the default configuration to accommodate the environment in which this lab is running.

Install Istio onto your Kubernetes cluster:

```
istioctl install -f install-manifest.yaml -y
```{{exec}}

After installation is complete, re-run `istioctl version`{{exec}}.

Note how the output now states that Istio is running in the control plane and the data plane.

List the namespaces in your Kubernetes cluster:

```
k get ns
```{{exec}}

Note the new Kubernetes namespace `istio-system`, also known as the Istio _root namespace_.

Review the deployments and services in the `istio-system` namespace:

```
k get deploy -n istio-system
```{{exec}}

```
k get svc -n istio-system
```{{exec}}

## Next

With Istio installed, we are ready to proceed to deploy an application to the mesh.
