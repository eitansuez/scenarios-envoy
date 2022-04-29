The file `direct-response.yaml` expands on the previous configuration file.

Review the file's contents:

```
cat direct-response.yaml
```{{exec}}

envoy now has an HTTP Connection Manager filter, configured to send a direct response back to the caller.

Run envoy in the background:

```
func-e run --config-path direct-response.yaml &
```{{exec}}

Send a request to `localhost:10000`:

```
curl -v localhost:10000
```{{exec}}

We now get an HTTP 200 response, with the "Hello!" response body.

Stop envoy: bring the process back to the foreground with `fg`, then press `ctrl+c`.