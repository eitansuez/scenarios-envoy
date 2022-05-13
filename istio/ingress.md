
Rather than configure routing for internal mesh clients, it's more interesting to configure an ingress gateway.

When installing Istio, an ingress gateway was provisioned alongside `istiod`.  Verify this:

```shell
kubectl get pod -n istio-system
```{{exec}}

Note that the gateway has a corresponding LoadBalancer type service:

```shell
kubectl get svc -n istio-system
```{{exec}}

In this environment, we can port-forward to the Istio ingressgateway service:

```plain
kubectl port-forward -n istio-system --address 0.0.0.0 service/istio-ingressgateway 1234:80 &
```{{exec}}

Note that the above command is now running in the background.  To terminate it, first bring it to the foreground with `fg` and then press `Ctrl+C`.

And then [access]({{TRAFFIC_HOST1_1234}}) Istio.

The Gateway is not yet configured, so you should get back a "connection refused" or "bad gateway" message.

Let's fix that..

### Configure the gateway

To expose HTTP port 80, apply the following gateway manifest:

```
cat gateway.yaml
```{{exec}}

The wildcard value for the `hosts` field ensures a match if the request is made directly to the "raw" gateway IP address.

```shell
kubectl apply -f gateway.yaml
```{{exec}}

Try once more to [access]({{TRAFFIC_HOST1_1234}}) the gateway. It should no longer return "connection refused". Instead you should get a 404 (not found).

### Bind the virtual service to the gateway

Study the following manifest:

```
cat gw-virtual-service.yaml
```{{exec}}

Note:

1. The additional `gateways` field ensures that the virtual service binds to the ingress gateway.
1. The `hosts` field has been relaxed to match any request coming in through the load balancer.

Apply the manifest:

```shell
kubectl apply -f gw-virtual-service.yaml
```{{exec}}

### Test the endpoints

The bare endpoint will still return a 404.

However, the [`/one`]({{TRAFFIC_HOST1_1234}}/one) and [`/two`]({{TRAFFIC_HOST1_1234}}/two) endpoints should now be functional, and return the ip and user-agent responses from each httpbin deployment, respectively.
