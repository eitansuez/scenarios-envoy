
Recall the ingress gateway IP address from the previous section:

```shell
GATEWAY_IP=$(kubectl get service istio-ingressgateway -n istio-system -ojsonpath='{.status.loadBalancer.ingress[0].ip}')
```{{exec}}

In order to have something to observe, we need to generate a load on our system.

```shell
for ((i=1;i<=600;i++)); do curl $GATEWAY_IP/one; curl $GATEWAY_IP/two; sleep 1; done
```{{exec}}
