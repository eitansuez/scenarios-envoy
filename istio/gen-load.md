
Capture the ingress gateway Cluster IP address:

```shell
GW_CLUSTER_IP=$(kubectl get svc -n istio-system istio-ingressgateway -ojsonpath='{.spec.clusterIP}')
```{{exec}}

In order to have something to observe, we need to generate a load on our system.

The following command will curl both endpoints every second from within the Kubernetes cluster:

```shell
k exec $SLEEP_POD -it -- "for ((i=1;i<=600;i++)); do curl $GW_CLUSTER_IP/one; curl $GW_CLUSTER_IP/two; sleep 1; done"
```{{exec}}
