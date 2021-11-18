

## Add Helm Repo

`helm repo add harbor https://helm.goharbor.io`
`helm install my-harbor harbor/harbor -n harbor -f infrastructure/harbor/my_values.yaml`

## References

- https://goharbor.io/docs/2.1.0/administration/configure-proxy-cache/