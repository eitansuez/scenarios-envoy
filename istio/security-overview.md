With Istio, deployed workloads are automatically assigned a unique identity.

Istio provides the [`PeerAuthentication`](https://istio.io/latest/docs/reference/config/security/peer_authentication/) CRD to control whether traffic within the mesh require mutual TLS exclusively, or whether it should be permissive.

The [`RequestAuthentication`](https://istio.io/latest/docs/reference/config/security/request_authentication/) CRD is used to turn on parsing and validation of JWT tokens.

Workload and user identity are the the basis for authentication.

The [`AuthorizationPolicy`](https://istio.io/latest/docs/reference/config/security/authorization-policy/) CRD provides powerful mechanism for applying authorization policies based on either workload or user identity, as well as arbitrary information from the request, such as specific request headers, JWT claims, and more.
