
The Istio distribution provides addons for a number of systems that together provide observability for the service mesh:

- [Zipkin](https://zipkin.io/) or [Jaeger](https://www.jaegertracing.io/) for distributed tracing
- [Prometheus](https://prometheus.io/) for metrics collection
- [Grafana](https://grafana.com/) provides dashboards for monitoring, using Prometheus as the data source
- [Kiali](https://kiali.io/) allows us to visualize the mesh

These addons are located in the `samples/addons/` folder of the distribution.

1. Navigate to the addons directory

    ```shell
    cd ~/istio-1.13.3/samples/addons
    ```{{exec}}

1. Deploy each addon:

    ```shell
    kubectl apply -f extras/zipkin.yaml
    ```{{exec}}

    ```shell
    kubectl apply -f prometheus.yaml
    ```{{exec}}

    ```shell
    kubectl apply -f grafana.yaml
    ```{{exec}}

    ```shell
    kubectl apply -f kiali.yaml
    ```{{exec}}

1. Verify that the `istio-system` namespace is now running additional workloads for each of the addons.

    ```shell
    kubectl get pod -n istio-system
    ```{{exec}}