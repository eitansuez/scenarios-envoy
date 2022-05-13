To deploy Envoy as a sidecar, we will employ the convenient [automatic sidecar injection](https://istio.io/latest/docs/setup/additional-setup/sidecar-injection/#automatic-sidecar-injection), which works as follows:

1. Label the target namespace with the special label `istio-injection` with the value `enabled`:

    ```shell
    kubectl label ns default istio-injection=enabled
    ```

    Verify:

    ```shell
    kubectl get ns -Listio-injection
    ```

1. When using `kubectl` to apply a deployment, Istio employs a Kubernetes [admission controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/){target=_blank} to augment the pod specification to bundle Envoy into a sidecar container.

    Verify this:  observe the presence of the istio sidecar injector in your Kubernetes cluster:

    ```shell
    kubectl get mutatingwebhookconfigurations
    ```