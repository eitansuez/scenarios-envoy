In the previous step, we saw Envoy load balance between two endpoints belonging to a single cluster.

In this step, we configure those two backing services differently:  we model two distinct clusters each with one endpoint.

Review the contents of the Envoy configuration file named `routing.yaml`:

```
cat routing.yaml
```{{exec}}

The route configuration now uses a path prefix to determine which backend cluster to target.

To help distinguish between the two backends, requests to the `/one` prefix will be routed to the `/ip` endpoint of the first cluster (`httpbin-1`), while rquests to the `/two` prefix go to the `/user-agent` endpoint of the second cluster.

Run Envoy in the background:

```
func-e run --config-path routing.yaml &
```{{exec}}

Send a request to Envoy, targeting the first backend:

```
curl localhost:10000/one
```{{exec}}

And another, targeting the second backend:

```
curl localhost:10000/two
```{{exec}}

Stop Envoy: bring the process back to the foreground with `fg`, then press `ctrl+c`.