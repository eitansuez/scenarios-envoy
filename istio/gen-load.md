
In order to have something to observe, we need to generate a load on our system.

First, let's configure port forwarding to the ingress gateway again:

```shell
kubectl port-forward -n istio-system --address 0.0.0.0 service/istio-ingressgateway 1234:80 &
```{{exec}}

The following command will "curl" both endpoints every second:

```
for ((i=1;i<=600;i++)); do curl {{TRAFFIC_HOST1_1234}}/one; sleep 1; done &
```{{exec}}

```
for ((i=1;i<=600;i++)); do curl {{TRAFFIC_HOST1_1234}}/two; sleep 1; done &
```{{exec}}