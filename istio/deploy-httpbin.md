We use [httpbin](https://httpbin.org/) as the application under test.

Istio conveniently provides httpbin as one of its [sample applications](https://github.com/istio/istio/tree/master/samples/httpbin).

For convenience, you will find a copy of the [`httpbin.yaml`](https://raw.githubusercontent.com/istio/istio/master/samples/httpbin/httpbin.yaml) Kubernetes manifest in your home directory.

Deploy `httpbin` to the default namespace:

```shell
kubectl apply -f httpbin.yaml
```{{exec}}

Istio also provides a convenient [sample app named sleep](https://github.com/istio/istio/tree/master/samples/sleep).

Deploy the [sleep](https://raw.githubusercontent.com/istio/istio/master/samples/sleep/sleep.yaml) client:

```shell
kubectl apply -f sleep.yaml
```{{exec}}

Observe that all pods in the `default` namespace each have two containers:

```shell
kubectl get pod -n default
```{{exec}}

Challenge: can you discover the name of the sidecar container?

<details>
  <summary>Hint<summary>
  <p>
  Describe any of the pods in the default namespace and study the `Containers` section.
  </p>
</details>