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
    - If successful, click the "Manage Hooks" box and click Save+Apply.

## Setup Jenkins Job

1) Go to the Jenkins UI
2) Click "New Item" on the left
3) Enter an item name, such as "capstone" and select Pipeline
4) Select the box for "Github project" and put in the URL to your Github project.
5) Select the box for GitHub hook trigger for GITScm polling
6) On the pipeline section, change definition to "Pipeline script from SCM"
7) Change SCM to Git
8) Paste your repository URL here (need to end with .git for this to work)
9) If your repository is private, you'll need to supply username+PAT here.
10) Since Github changed to default to main, be sure to update the Branches to build to match that.

Sadly, since this is a local Jenkins setup, we don't have a URL for Github to push webhooks to,
but we're setup for that in the event that changes.
