### Inspect the Gateway's Envoy configuration

1. Review the listeners configuration.

    ```shell
    istioctl proxy-config listener deploy/istio-ingressgateway.istio-system
    ```{{exec}}

1. Next study the routes configuration.

    ```shell
    istioctl proxy-config route deploy/istio-ingressgateway.istio-system
    ```{{exec}}

1. Zero-in on the routes configuration named `http.8080`

    ```shell
    istioctl proxy-config route deploy/istio-ingressgateway.istio-system --name http.8080 -o yaml
    ```{{exec}}

It's worthwhile taking a close look at the output. Below I have removed some of the noise to highlight the most salient parts:

```yaml
    ...
    routes:
    - ...
      match:
        ...
        prefix: /one
      ...
      route:
        cluster: outbound|8000||httpbin.default.svc.cluster.local
        ...
        prefixRewrite: /ip
        ...
    - ...
      match:
        ...
        prefix: /two
      ...
      route:
        cluster: outbound|8000||httpbin-2.default.svc.cluster.local
        ...
        prefixRewrite: /user-agent
        ...
```

Challenge: Review the hand-written configuration from the "Intro to Envoy" lab.  How does it compare to the above generated configuration?
