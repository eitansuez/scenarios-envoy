FILE=/ks/wait-init.sh; while ! test -f ${FILE}; do clear; sleep 0.1; done; bash ${FILE}
export ISTIO_VERSION=1.13.3
curl -L https://istio.io/downloadIstio | TARGET_ARCH=x86_64 sh -
echo "export PATH=/root/istio-${ISTIO_VERSION}/bin:\$PATH" >> .bashrc
export PATH=/root/istio-${ISTIO_VERSION}/bin:$PATH
mv /tmp/minimal-with-cni.yaml /root/istio-${ISTIO_VERSION}/manifests/profiles/
istioctl install -y -f /root/istio-${ISTIO_VERSION}/manifests/profiles/minimal-with-cni.yaml
