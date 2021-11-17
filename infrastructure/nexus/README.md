

## Login to Nexus

Get the Nexus password via `kubectl exec -n nexus -it svc/nexus-repository-manager -- cat /nexus-data/admin.password && echo`
Username is `admin`.

## References

- https://help.sonatype.com/repomanager3/installation/configuring-the-runtime-environment
- https://hub.docker.com/r/sonatype/nexus3/
- https://help.sonatype.com/repomanager3/installation/installation-methods

- https://artifacthub.io/packages/helm/oteemo-charts/sonatype-nexus
- https://baykara.medium.com/how-to-automate-nexus-setup-process-5755183bc322
- https://github.com/mbaykara/nexus-automation/tree/master/scripts
- https://github.com/sonatype-nexus-community/nexus-scripting-examples