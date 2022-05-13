### Destination Rules

With Istio, you can apply the [DestinationRule](https://istio.io/latest/docs/reference/config/networking/destination-rule/)
CRD (Custom Resource Definition) to configure traffic policy: the details of how clients call a service.

Specifically, you can configure:

- **Load balancer settings**: which load balancing algorithm to use
- **Connection pool settings**: for both `tcp` and `http` connections, configure the volume of connections, retries, timeouts, etc..
- **Outlier detection**: under what conditions to evict an unhealthy endpoints, and for how long
- **TLS mode**: whether a connection to an upstream service should use plain text, TLS, mutual TLS using certificates you specify, or mutual TLS using Istio-issued certificates.

Explore applying a destination rule to alter the load balancer configuration.

!!! question "Did you know?"

    What is the default load balancing algorithm currently in play for calls to `httpbin`?

    Visit the Istio configuration reference [here](https://istio.io/latest/docs/reference/config/networking/destination-rule/#LoadBalancerSettings-SimpleLB) to find out.

Study the contents of the file `destination-rule.yaml`:

```
cat destination-rule.yaml
```{{exec}}

Apply the destination rule, which alters the load balancing algorithm to `LEAST_CONN`:

```
kubectl apply -f destination-rule.yaml
```{{exec}}

In Envoy, the load balancer policy is associated to a given upstream service, in Envoy's terms, it's in the "cluster" config.

Look for `lbPolicy` field in cluster configuration YAML output:

```
istioctl proxy-config cluster $SLEEP_POD --fqdn httpbin.default.svc.cluster.local -o yaml | grep lbPolicy -A 3 -B 3
```{{exec}}

Note in the output the value of `lbPolicy` should say `LEAST_REQUEST`, which is [Envoy's name](https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/cluster/v3/cluster.proto.html#enum-config-cluster-v3-cluster-lbpolicy) for Istio's `LEAST_CONN` setting.

Verify that the Envoy configuration was altered and that client calls now follow the "least request" algorithm.
