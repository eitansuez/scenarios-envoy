In comparison to having to configure Envoy proxies manually, Istio provides a mechanism to configure Envoy proxies with much less effort.
It draws on information from the environment: awareness of running workloads (service discovery) provides the inputs necessary to derive Envoy's clusters and listeners configurations automatically.

Istio Custom Resource Definitions complement and complete the picture by providing mechanisms to configure routing rules, authorization policies and more.

Istio goes one step further: it dynamically reconfigures the Envoy proxies any time that services are scaled, or added to and removed from the mesh.

Istio and Envoy together provide a foundation for running microservices at scale.

In the next lab, we turn our attention to Web Assembly, a mechanism for extending and customizing the behavior of the Envoy proxies running in the mesh.

