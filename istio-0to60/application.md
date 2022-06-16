In this lab you will deploy an application to your mesh.

- The application consists of two microservices, `web-frontend` and `customers`.
- The `customers` service exposes a REST endpoint that returns a list of customers in JSON format.
- The `web-frontend` calls `customers` to retrieve the list, which it uses to render to HTML.

The respective Docker images for these services have already been built and pushed to a Docker registry.

You will deploy the application to the `default` Kubernetes namespace.

But before proceeding, you must enable sidecar injection.

## Enable automatic sidecar injection

There are two options for [sidecar injection](https://istio.io/latest/docs/setup/additional-setup/sidecar-injection/): automatic and manual.

In this lab we will use automatic injection, which involves labeling the namespace where the pods are to reside.

1.  Label the default namespace

    ```
    kubectl label namespace default istio-injection=enabled
    ```{{exec}}

1. Verify that the label has been applied:

    ```
    kubectl get ns -Listio-injection
    ```{{exec}}

## Deploy the application

1. Study the two Kubernetes yaml files: `web-frontend.yaml` and `customers.yaml`.

      ```
      cat web-frontend.yaml
      ```{{exec}}

      ```
      cat customers.yaml
      ```{{exec}}

    Each file defines its corresponding deployment, service account, and ClusterIP service.

1. Apply the two files to your Kubernetes cluster.

    ```
    k apply -f customers.yaml
    ```{{exec}}

    ```
    k apply -f web-frontend.yaml
    ```{{exec}}

Confirm that:

- Two pods are running, one for each service
- Each pod consists of two containers, the one running the service image, plus the Envoy sidecar

    ```
    k get pod
    ```{{exec}}

## How did each pod end up with two containers?

Istio installs a Kubernetes object known as a [mutating webhook admission controller](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/): logic that intercepts Kubernetes object creation requests and that has the permission to alter (mutate) what ends up stored in etcd (the pod spec).

You can list the mutating webhooks in your Kubernetes cluster and confirm that the sidecar injector is present.

```
k get mutatingwebhookconfigurations
```{{exec}}

## Verify access to each service

We wish to deploy a pod that runs a `curl` image so we can verify that each service is reachable from within the cluster.
The Istio distribution provides a sample app called `sleep` that will serve this purpose.

1. Deploy `sleep` to the default namespace.

    ```
    cat sleep.yaml
    ```{{exec}}

    ```
    k apply -f sleep.yaml
    ```{{exec}}

1.  Confirm that the sleep pod is running before proceeding.

    ```
    k get pod
    ```{{exec}}

1. Capture the name of the sleep pod to an environment variable

    ```
    SLEEP_POD=$(kubectl get pod -l app=sleep -ojsonpath='{.items[0].metadata.name}')
    ```{{exec}}

1. Use the `kubectl exec` command to call the `customers` service.

    ```
    k exec $SLEEP_POD -it -- curl customers
    ```{{exec}}

    The console output should show a list of customers in JSON format.

1. Call the `web-frontend` service

    ```
    kubectl exec $SLEEP_POD -it -- curl web-frontend | head
    ```{{exec}}

    The console output should show the start of an HTML page listing customers in an HTML table.

## Next

In the next lab, we expose the `web-frontend` using an Istio Ingress Gateway.

This will allow us to access this application on the web.
