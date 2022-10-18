This lab explores one of the main strengths of Istio: observability.

The services in our mesh are automatically observable, without adding any burden on developers.

## Deploy the Addons

The Istio distribution provides addons for a number of systems that together provide observability for the service mesh:

- [Zipkin](https://zipkin.io/) or [Jaeger](https://www.jaegertracing.io/) for distributed tracing
- [Prometheus](https://prometheus.io/) for metrics collection
- [Grafana](https://grafana.com/) provides dashboards for monitoring, using Prometheus as the data source
- [Kiali](https://kiali.io/) allows us to visualize the mesh

These addons are located in the `samples/addons/` folder of the distribution.

1. Navigate to the addons directory

    ```
    cd ~/istio-1.15.2/samples/addons
    ```{{exec}}

1. Deploy each addon:

    ```
    k apply -f extras/zipkin.yaml
    ```{{exec}}

    ```
    k apply -f prometheus.yaml
    ```{{exec}}

    ```
    k apply -f grafana.yaml
    ```{{exec}}

    ```
    k apply -f kiali.yaml
    ```{{exec}}

1. Verify that the `istio-system` namespace is now running additional workloads for each of the addons.

    ```
    k get pod -n istio-system
    ```{{exec}}

## Generate a load

In order to have something to observe, we need to generate a load on our system.

### Install a load generator

Install a simple load generating tool named [`siege`](https://github.com/JoeDog/siege).

```
apt-get install siege
```{{exec}}

### Generate a load

With `siege` now installed, familiarize yourself with the command and its options.

```
siege --help
```{{exec}}

Run the following command to generate a mild load against the application.

```
INGRESS_CLUSTER_IP=$(kubectl get svc -n istio-system istio-ingressgateway -ojsonpath='{.spec.clusterIP}')
```{{exec}}

```
siege --delay=3 --concurrent=3 --time=20M http://$INGRESS_CLUSTER_IP/
```{{exec}}

### Note

The `siege` command stays in the foreground while it runs.
It may be simplest to leave it running, and open a separate terminal in your cloud shell environment.

## About the dashboards

The `istioctl` CLI provides convenience commands for accessing the web UIs for each dashboard.

Take a moment to review the help information for the `istioctl dashboard` command:

```
istioctl dashboard --help
```{{exec}}

One normally launches dashboards with the above command.

In this environment however, you will use the `kubectl port-forward` command explicitly.


## Kiali

Expose the Kiali dashboard with the following command:

```
k port-forward -n istio-system --address 0.0.0.0 service/kiali 20001:20001
```{{exec}}

[Access kiali via port 20001]({{TRAFFIC_HOST1_20001}}/).

### Note

The `kubectl port-forward` command also blocks.
Leave it running until you're finished using the dashboard, at which time 
pressing _Ctrl+C_ can interrupt the process and put you back at the terminal prompt.

The Kiali dashboard displays.

Customize the view as follows:

1. Select the _Graph_ section from the sidebar.
1. Under _Select Namespaces_ (at the top of the page), select the `default` namespace, the location where the application's pods are running.
1. From the third "pulldown" menu, select _App graph_.
1. From the _Display_ "pulldown", toggle on _Traffic Animation_ and _Security_.
1. From the footer, toggle the legend so that it is visible.  Take a moment to familiarize yourself with the legend.

Observe the visualization and note the following:

- We can see traffic coming in through the ingress gateway to the `web-frontend`, and the subsequent calls from the `web-frontend` to the `customers` service
- The lines connecting the services are green, indicating healthy requests
- The small lock icon on each edge in the graph indicates that the traffic is secured with mutual TLS

Such visualizations are helpful with understanding the flow of requests in the mesh, and with diagnosis.

Feel free to spend more time exploring Kiali.

We will revisit Kiali in a later lab to visualize traffic shifting such as when performing a blue-green or canary deployment.

### Kiali Cleanup

Close the Kiali dashboard.  Interrupt the `kubectl port-forward` command by pressing _Ctrl+C_.


## Zipkin

Launch the Zipkin dashboard:

```
k port-forward -n istio-system --address 0.0.0.0 service/zipkin 9411:9411
```{{exec}}

[Access Zipkin via port 9411]({{TRAFFIC_HOST1_9411}}/).

The Zipkin dashboard displays.

- Click on the red '+' button and select _serviceName_.
- Select the service named `web-frontend.default` and click on the _Run Query_ button (lightblue) to the right.

A number of query results will display.  Each row is expandable and will display more detail in terms of the services participating in that particular trace.

- Click the _Show_ button to the right of one of the traces having four (4) spans.

The resulting view shows spans that are part of the trace, and more importantly how much time was spent within each span.  Such information can help diagnose slow requests and pin-point where the latency lies.

Distributed tracing also helps us make sense of the flow of requests in a microservice architecture.

### Zipkin Cleanup

Close the Zipkin dashboard.  Interrupt the `kubectl port-forward` command with _Ctrl+C_.


## Prometheus

Prometheus works by periodically calling a metrics endpoint against each running service (this endpoint is termed the "scrape" endpoint).  Developers normally have to instrument their applications to expose such an endpoint and return metrics information in the format the Prometheus expects.

With Istio, this is done automatically by the Envoy sidecar.

### Observe how Envoy exposes a Prometheus scrape endpoint

1. Capture the customers pod name to a variable.

    ```
    CUSTOMERS_POD=$(kubectl get pod -l app=customers -ojsonpath='{.items[0].metadata.name}')
    ```{{exec}}

1. Run the following command:

    ```
    k exec $CUSTOMERS_POD -it -- curl localhost:15090/stats/prometheus  | grep istio_requests
    ```{{exec}}

    The list of metrics returned by the endpoint is rather lengthy, so we just peek at "istio_requests" metric.  The full response contains many more metrics.

### Access the dashboard

1. Start the prometheus dashboard

    ```
    k port-forward -n istio-system --address 0.0.0.0 service/prometheus 9090:9090
    ```{{exec}}

    [Access Prometheus via port 9090]({{TRAFFIC_HOST1_9090}}/).

1. In the search field enter the metric named `istio_requests_total`, and click the _Execute_ button (on the right).

1. Select the tab named _Graph_ to obtain a graphical representation of this metric over time.

    Note that you are looking at requests across the entire mesh, i.e. this includes both requests to `web-frontend` and to `customers`.

1. As an example of Prometheus' dimensional metrics capability, we can ask for total requests having a response code of 200:

    ```
    istio_requests_total{response_code="200"}
    ```

1. With respect to requests, it's more interesting to look at the rate of incoming requests over a time window.  Try:

    ```
    rate(istio_requests_total[5m])
    ```

There's much more to the Prometheus query language ([this](https://prometheus.io/docs/prometheus/latest/querying/basics/) may be a good place to start).

Grafana consumes these metrics to produce graphs on our behalf.

- Close the Prometheus dashboard and terminate the corresponding `kubectl port-forward` command.

## Grafana

1. Launch the Grafana dashboard

    ```
    k port-forward -n istio-system --address 0.0.0.0 service/grafana 3000:3000
    ```{{exec}}

    [Access Grafana via port 3000]({{TRAFFIC_HOST1_3000}}/).

1. From the sidebar, select _Dashboards_ --> _Browse_
1. Click on the folder named _Istio_ to reveal pre-designed Istio-specific Grafana dashboards
1. Explore the Istio Mesh Dashboard.  Note the Global Request Volume and Global Success Rate.
1. Navigate back to _Dashboards_ and explore the Istio Service Dashboard.  First select the service `web-frontend` and inspect its metrics, then switch to the `customers` service and review its dashboard.
1. Navigate back to _Dashboards_ and explore the Istio Workload Dashboard.  Select the `web-frontend` workload.  Look at Outbound Services and note the outbound requests to the customers service.  Select the `customers` workload and note that it makes no Oubtound Services calls.

Feel free to further explore these dashboards.

## Cleanup

1. Terminate the `kubectl port-forward` command (_Ctrl+C_)
1. Likewise terminate the `siege` command
1. Navigate back to the home directory: `cd ~`

## Next

We turn our attention next to security features of a service mesh.
