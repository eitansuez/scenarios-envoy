The objective of this lab is to expose the `web-frontend` service to the internet.

## The Ingress gateway

When you installed Istio, in addition to deploying istiod to Kubernetes, the installation also provisioned an Ingress Gateway.

View the corresponding Istio ingress gateway pod in the `istio-system` namespace.

```
k get pod -n istio-system
```{{exec}}

A corresponding _LoadBalancer_ type service was also created:

```
k get svc -n istio-system
```{{exec}}

In this lab environment, the load-balancer service does not have a corresponding public IP address.

Instead, we can expose the ingress gateway service via a port on the host node:

```
kubectl port-forward -n istio-system --address 0.0.0.0 service/istio-ingressgateway 1234:80
```{{exec}}

We can then [access the gateway via port 1234]({{TRAFFIC_HOST1_1234}}/).

Currently, the gateway is not configured to allow access so you should get a "connection refused" response.

## Configuring ingress

Configuring ingress with Istio is accomplished in two parts:

1. Define a `Gateway` custom resource that governs the specific host, port, and protocol to expose
1. Specify how requests should be routed with a `VirtualService` custom resource.

### Create a Gateway resource

1. Review the following Gateway specification.

    ```
    cat gateway.yaml
    ```{{exec}}

    Above, we specify the HTTP protocol, port 80, and a wildcard ("*") host matcher which ensures that HTTP requests using any host name or IP value will match.

    The selector _istio: ingressgateway_ ensures that this gateway resource binds to the physical ingress gateway.

1. Apply the gateway resource to your cluster.

    ```
    k apply -f gateway.yaml
    ```{{exec}}

1. Attempt once more to [access the gateway via port 1234]({{TRAFFIC_HOST1_1234}}/).  It should return a 404 (not found) response.

### Create a VirtualService resource

1. Review the following VirtualService specification.

    ```
    cat web-frontend-virtualservice.yaml
    ```{{exec}}

    Note how this specification references the name of the gateway ("frontend-gateway"), a matching host ("*"), and specifies a route for requests to be directed to the `web-frontend` service.

1. Apply the virtual service resource to your cluster.

    ```
    k apply -f web-frontend-virtualservice.yaml
    ```{{exec}}

1. List virtual services in the default namespace.

    ```
    k get virtualservice
    ```{{exec}}

    The output indicates that the virtual service named `web-frontend` is bound to the gateway, as well as any hostname that routes to the load balancer IP address.

Finally, verify that you can now [access]({{TRAFFIC_HOST1_1234}}/) `web-frontend` from your web browser.

## Candidate follow-on exercises

We will not explore ingress any further in this workshop.  Consider the following as independent exercises:

- Creating a DNS A record for the gateway IP, and narrowing down the scope of the gateway to only match that hostname.
- [Configuring a TLS ingress gateway](https://istio.io/latest/docs/tasks/traffic-management/ingress/secure-ingress/#configure-a-tls-ingress-gateway-for-a-single-host)
 

## Next

The application is now running and exposed on the internet.

In the next lab, we turn our attention to the observability features that are built in to Istio.
