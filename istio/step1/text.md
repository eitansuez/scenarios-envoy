
Istio has been installed using the minimal profile.

1. Check the installed version:

    ```
    istioctl version
    ```{{exec}}

1. Label the default namespace for automatic injection:

    ```
    k label ns default istio-injection=enabled
    ```{{exec}}

1. Deploy the `helloworld` sample:

    ```
    k apply -f istio-1.13.3/samples/helloworld/helloworld.yaml
    ```{{exec}}

Wait for the two pods to be ready.

```
k wait deploy/helloworld-v1 --for condition=available --timeout=3m
k wait deploy/helloworld-v2 --for condition=available --timeout=3m
```{{exec}}
