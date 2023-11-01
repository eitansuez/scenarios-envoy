A Kubernetes cluster was provisioned on your behalf.

Verify that `kubectl` is configured:

```
k get ns
```{{exec}}

## Install Istio

You will be using Istio version 1.19.3:

```
export ISTIO_VERSION=1.19.3
```{{exec}}

Download the Istio distribution:

```
curl -L https://istio.io/downloadIstio | TARGET_ARCH=x86_64 sh -
```{{exec}}

Note the istio distribution folder `istio-1.19.3` in your home directory:

```
ls -lF
```{{exec}}

The Istio CLI, `istioctl` is located in the distribution's `bin` directory.

Place `istioctl` in your `$PATH`:

```
cp istio-1.19.3/bin/istioctl /usr/local/bin
```{{exec}}

Verify that the CLI is functioning:

```
istioctl version
```{{exec}}

Note how the output of the above command states in so many words that Istio is not yet installed in your Kubernetes cluster, but that the client version is 1.19.3.

### Pre-check

The `istioctl` CLI provides a convenient `precheck` command that can be used to "_inspect a Kubernetes cluster for Istio install and upgrade requirements._"

To verify whether it is safe to install Istio on your Kubernetes cluster, run:

```
istioctl x precheck
```{{exec}}

Make sure that the output of the above command returns a green "checkmark" stating that no issues were found when checking the cluster.

### Install

The file `install-manifest.yaml` is a configuration of Istio that tweaks the default configuration to accommodate the environment in which this lab is running.

Install Istio onto your Kubernetes cluster:

```
istioctl install -f install-manifest.yaml -y
```{{exec}}

## Verify that Istio is installed

Post-installation, Istio provides the command `verify-install`: it runs a series of checks to ensure that the installation was successful and complete.

Go ahead and run it:

```
istioctl verify-install
```{{exec}}

Inspect the output and confirm that the it states that "_✔ Istio is installed and verified successfully._"

Let's keep probing.

Re-run `istioctl version`{{exec}}.

Note how the output now states that Istio is running both in the control plane _and_ the data plane.

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
