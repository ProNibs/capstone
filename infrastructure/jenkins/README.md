# Overview

Need to create namespace for Jenkins, add helm repo, and then install the chart.

Reference: [Jenkins Kubernetes Install page](https://www.jenkins.io/doc/book/installing/kubernetes/)

## Initial Install with Helm

```
helm repo add jenkinsci https://charts.jenkins.io
helm repo update
```


## Setup Jenkins to auto-poll Github

Assuming Github being used here!

1) Create a Personal Access Token (PAT) in Github.
2) Add the PAT to Jenkins
    -  Go to the Jenkins UI->Manage Jenkins->Manage Credentials->Jenkins (under stores scoped to Jenkins->
        Global credentials (unrestricted). On the left-hand side is "Add Credentials".
    - Ensure the "kind" dropdown is "Secret Text". Paste your PAT in the "Secret" field.
    - Decide on an ID and description you like.
3) Setup the Github Server to use the token
    - Go to Jenkins UI->Manage Jenkins->Configure System
    - Go to the GitHub section and click "Add Github Server"
    - Pick your credentials and the "Test Connection" box
    - If succesful, click the "Manage Hooks" box and click Save+Apply.