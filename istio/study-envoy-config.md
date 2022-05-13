The Istio CLI, `istioctl`, provides a handy subcommand `proxy-config`, that will help us get at the configuration of the Envoy proxy in the sleep pod: its listeners, routes, clusters, and endpoints.

Capture the name of the sleep pod to a variable:

```shell
SLEEP_POD=$(kubectl get pod -l app=sleep -ojsonpath='{.items[0].metadata.name}')
```{{exec}}

#### Envoy's listeners configuration

Run the following command:

```shell
istioctl proxy-config listener $SLEEP_POD
```{{exec}}

The output displays a high-level overview of the Envoy listener configuration. From this output we learn that Envoy has multiple listeners, listening on multiple ports.

Some listeners handle inbound requests, for example there's a health endpoint on port `15021`, and a prometheus scrape endpoint on port `15090`.

The listener on port `8000` (which matches the port number of the httpbin cluster IP service) is responsible for handling requests bound to the `httpbin` service.

To see the full listener section of the Envoy configuration for port `8000`, run:

```shell
istioctl proxy-config listener $SLEEP_POD --port 8000 -o yaml > listeners.yaml
```{{exec}}

The output is voluminous (~ 200+ lines) and that's why we piped it into the `listeners.yaml` file.

Note the following:

- `trafficDirection` (at the very end of the output) is set to `OUTBOUND`
- The `address` section specifies the address and port that the listener is configured for:

    ```yaml
    address:
        socketAddress:
        address: 0.0.0.0
        portValue: 8000
    ```

- The configuration contains a `filterChains` field:

    ```yaml
    filterChains:
    - filterChainMatch:
        applicationProtocols:
        ...
    ```

- The filter chain contains a filter named `envoy.filters.network.http_connection_manager`, and its list of `httpFilters` ends with the `router` filter:

    ```yaml
            httpFilters:
            - name: istio.metadata_exchange
            - ...
            - name: envoy.filters.http.router
            typedConfig:
                '@type': type.googleapis.com/envoy.extensions.filters.http.router.v3.Router
    ```

All of the above facts should match with what you learned in the [Introduction to Envoy](../envoy).

#### Routes

Similar to the `proxy-config listener` command, the high-level overview for routes is the following command:

```shell
istioctl proxy-config route $SLEEP_POD
```{{exec}}

Zero-in on the route configuration for port `8000`:

```shell
istioctl proxy-config route $SLEEP_POD --name 8000 -o yaml
```{{exec}}

The output will show the route configuration, including this section:

```yaml
    ...
    routes:
    - decorator:
        operation: httpbin.default.svc.cluster.local:8000/*
      match:
        prefix: /
      name: default
      route:
        cluster: outbound|8000||httpbin.default.svc.cluster.local
    ...
```

The above output states that calls to the httpbin service should be routed to the cluster named `outbound|8000||httpbin.default.svc.cluster.local`.

#### Clusters

We can view all Envoy clusters with:

```shell
istioctl proxy-config cluster $SLEEP_POD
```{{exec}}

And specifically look at the configuration for the httpbin cluster with:

```shell
istioctl proxy-config cluster $SLEEP_POD --fqdn httpbin.default.svc.cluster.local -o yaml
```{{exec}}

#### Endpoints

More importantly, we'd like to know what are the endpoints backing the `httpbin` cluster.

```shell
istioctl proxy-config endpoint $SLEEP_POD --cluster "outbound|8000||httpbin.default.svc.cluster.local"
```{{exec}}

Verify that the endpoint addresses from the output in fact match the pod IPs of the `httpbin` workloads:

```shell
kubectl get pod -l app=httpbin -o wide
```{{exec}}
