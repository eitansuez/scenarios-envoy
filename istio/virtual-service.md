Let's move on to a new scenario.

1. Scale back the `httpbin` deployment to a single replica:

    ```
    kubectl scale deploy httpbin --replicas=1
    ```{{exec}}

1. Deploy a second httpbin service

    ```
    kubectl apply -f httpbin-2.yaml
    ```{{exec}}

    The above manifest is a separate deployment of `httpbin`, named `httpbin-2`.

### Apply the routing configuration: `VirtualService`

If you recall, back in the Envoy lab, you wrote Envoy routing configuration involving path prefixes and rewrites.

In Istio, the routing configuration is exposed as a Kubernetes custom resource of kind `VirtualService`.

Study the manifest file `virtual-service.yaml` shown below:

```
cat virtual-service.yaml
```{{exec}}

It states: when making requests to the `httpbin` host, route the request to either the first destination (`httpbin`) or the second (`httpbin-2`), as a function of the path prefix in the request URL.

Apply the manifest:

```
kubectl apply -f virtual-service.yaml
```{{exec}}
