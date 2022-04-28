Instead of encoding a response directly in the envoy configuration, we wish configure envoy to proxy requests to a backend service.

In fact, why not create two backend services, and watch envoy load-balance requests between the two endpoints?

Use docker to run an instance of [httpbin](https://httpbin.org/) on port 8100:

```
docker run -d -p 8100:80 kennethreitz/httpbin
```{{exec}}

Run a second instance on port 8200:

```
docker run -d -p 8200:80 kennethreitz/httpbin
```{{exec}}

Verify that the two docker containers are up and running:

```
docker ps
```{{exec}}

Next, inspect the contents of the envoy configuration file named `clusters.yaml`:

```
cat clusters.yaml
```{{exec}}

The route configuration now routes requests to the cluster named `httpbin`, defined in a separate configuration section.

Note how the cluster is configured with two endpoints using an address and port number matching each of the two docker instances you just launched.

Run envoy in the background:

```
func-e run --config-path clusters.yaml &
```{{exec}}

Send a token request envoy:

```
curl localhost:10000/headers
```{{exec}}

And another:

```
curl localhost:10000/html
```{{exec}}

Stop envoy: bring the process back to the foreground with `fg`, then press `ctrl+c`.