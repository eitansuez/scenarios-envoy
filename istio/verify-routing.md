Verify that requests to `/one` are routed to the `httpbin` deployment's `/ip` endpoint, and that requests to `/two` are routed to the `httpbin-2` deployment's `/user-agent` endpoint.

1. Tail the logs of the `httpbin` pod's `istio-proxy` container:

    ```shell
    HTTPBIN_POD=$(kubectl get pod -l app=httpbin -ojsonpath='{.items[0].metadata.name}')
    kubectl logs --follow $HTTPBIN_POD -c istio-proxy
    ```{{exec}}

1. In a separate terminal, tail the `httpbin-2` pod's logs:

    ```shell
    HTTPBIN2_POD=$(kubectl get pod -l app=httpbin-2 -ojsonpath='{.items[0].metadata.name}')
    kubectl logs --follow $HTTPBIN2_POD -c istio-proxy
    ```{{exec}}

1. Separately, make repeated calls to the `/one` endpoint from the `sleep` pod:

    ```shell
    SLEEP_POD=$(kubectl get pod -l app=sleep -ojsonpath='{.items[0].metadata.name}')
    kubectl exec $SLEEP_POD -it -- curl httpbin:8000/one
    ```{{exec}}

1. Likewise, make repeated calls to the `/two` endpoint from the `sleep` pod:

    ```shell
    SLEEP_POD=$(kubectl get pod -l app=sleep -ojsonpath='{.items[0].metadata.name}')
    kubectl exec $SLEEP_POD -it -- curl httpbin:8000/two
    ```{{exec}}
