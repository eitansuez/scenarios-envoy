
The file `minimal-config.yaml` is just that: it contains the minimum configuration necessary to start envoy.

Review the file's contents:

```
cat minimal-config.yaml
```{{exec}}

Envoy will listen on port 10000, and is configured with no filters.

Run Envoy in the background:

```
func-e run --config-path minimal-config.yaml &
```{{exec}}

Try to send a request to `localhost:10000`:

```
curl -v localhost:10000
```{{exec}}

Envoy does not yet know how to route the request.

Stop Envoy: bring the process back to the foreground with `fg`, then press `ctrl+c`.