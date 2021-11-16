# Overview


## Create Memberlist secret

`kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" `

## Check if IPVS is in Strict ARP Mode

- `kubectl describe cm -n kube-system kube-proxy | grep strict`
    - If strictARP: true, you're fine. Get to installing!
- ```bash
    kubectl get configmap kube-proxy -n kube-system -o yaml | \
    sed -e "s/strictARP: false/strictARP: true/" | \
    kubectl apply -f - -n kube-system
  ```

## Install

- Supposed to install via Jenkins pipeline, but if you want to do it manually
- `kapp deploy -a metallb.kapp -c -f <(ytt -f k8s/)`

## For local kind cluster

- Update config.yaml to match what cidr returns from `docker network inspect -f '{{.IPAM.Config}}' kind`
- Don't need to run `get_public_ips.sh` as this is static.
- Remember to double-check Strigo private IPs and adjust default back to proper /16 private IPs.

## References

[MetalLB Install Docs](https://metallb.universe.tf/installation/)
