Scale httpbin to two replicas:

```shell
kubectl scale deploy httpbin --replicas=2
```{{exec}}

Having two pods will give us the two endpoints to load-balance across.

Verify that requests from `sleep` are load-balanced across the two `httpbin` endpoints.

1. Tail the logs of each Envoy sidecar on the receiving end.

    In one terminal, run:

    ```shell
    HTTPBIN_POD_1=$(kubectl get pod -l app=httpbin -ojsonpath='{.items[0].metadata.name}')
    kubectl logs --follow $HTTPBIN_POD_1 -c istio-proxy
    ```{{exec}}

    In a second terminal, run:

    ```shell
    HTTPBIN_POD_2=$(kubectl get pod -l app=httpbin -ojsonpath='{.items[1].metadata.name}')
    kubectl logs --follow $HTTPBIN_POD_2 -c istio-proxy
    ```{{exec}}

1. Make repeated calls from the `sleep` container to the httbin service and observe which of the two `httpbin` pods receives the request.

    ```shell
    SLEEP_POD=$(kubectl get pod -l app=sleep -ojsonpath='{.items[0].metadata.name}')
    kubectl exec $SLEEP_POD -it -- curl httpbin:8000/html
    ```

You can stop following the logs by pressing ++ctrl+c++ and close the first two terminal windows.
