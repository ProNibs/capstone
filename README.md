# Overview

This is my capstone project for Flatiron school.
The capstone utilizes 3 git repos for deploying 3 microservices to display a React Frontend.
The rest of this README details my work and what I did.

## Setup Git repo

* Create repo on Github
* `git clone` the repo
* `git checkout -b develop` to create a new branch named "develop"
* Fork **all** of the repos provided by Flatiron to personal Github
    * This is so I can edit the code on my own if desired
* Use [Git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to pull in the three forked repos
    * `git submodule add "URL"`
    * If looking to clone this from scratch, need to run the following:
        * `git submodule init`
        * `git submodule update`
    * In order to update the submodules:
        * cd to the directory the submodule corresponds to
        * `git fetch`
        * Changes are now available locally

## Creating Dockerfiles for each microservice

### Create Dockerfile for aggregatorService (Go API backend)

* Create a Dockerfile in the aggregatorService directory for golang
* Just go look at it, don't want to spend time detailing how to make Dockerfiles for go.
    * I put comments into the Dockerfile even.
* Of note is that the go service defaults to port 7777.
* Verify the Dockerfile works:
    * `docker build -t aggregatorservice:1.0 .`
    * `docker run --rm -p 7777:7777 aggregatorservice:1.0`
    * `curl localhost:7777/ping`
    * Should receive a JSON detailing status: OK

### Review dashboard-database (Postgres)

* Ensure git submodule was created correctly
* This one has a Dockerfile already, so should be good to go
* Variables of note:
    * 5432 is default port
    * User=postgres, Password=password, Database=postgres
    * SQL scripts create a user named `mcmsuser` with password `mcmsuser123!`
* Verify Dockerfile works:
    * `docker build -t mcmsdb:1.0 .`
    * `docker run --rm --name mcmsdb -it mcmsdb:1.0`
    * If you want to get the down and dirty psql:
        * `docker exec -it mcmsdb bash`
        * Of note, `psql -U mcmsuser` will not work, so need to login as `postgres` user and swap to `mcmsuser`.
        * However, without doing above, can see the user exists with `\du`.

### Create Dockerfile for dashboard-api (Java Spring Backend)

* Ensure git submodule was created correctly
* Variables of note:
    * 8080 is default port
    * Assumes postgresql is running on localhost:5432
    * Uses the `mcmsuser` for postgres database as mentioned above
* Create Dockerfile and test it:
    * **Note:** For my Dockerfile to work, I updated build.gradle with jar {enabled = false}. 
    * `docker build -t dashboard-api:1.0 .`
    * `docker network create apinet`
    * `docker run --rm --network=apinet --name mcmsdb mcmsdb:1.0`
    * Update MCMSDataSourceConfig.java and flyway.conf with `mcmsdb:5432` instead of `localhost:5432`
    * `docker run --rm -p 8080:8080 --network=apinet dashboard-api:1.0`
    * `curl localhost:8080/api/v1/condenser`
        * If everything is working, should get a json response of pre-populated data.

### Create Dockerfile for dashboard-web (NPM-React Frontend)

* Ensure git submodule was created correctly
* Variables of note:
    * 3000 is default port
    * localhost:8080 for connection to condensor in apiSlice
    * localhost:7777/condenser for Aggregator is used in AggregatorInfo
* Create Dockerfile and test it:
    * `docker build -t dashboard-web:1.0 .`
    * `docker run --rm -p 80:80 dashboard-web:1.0`
    * `curl localhost:80`

### Create Dockerfile for supplementalService (Node.js backend)

* Ensure git submodule was created correctly
* Variables of note:
    * 3001 is default port
* Create Dockerfile and test it:
    * `docker build -t supplementalservice:1.0 .`
    * `docker run --rm -p 3001:3001 supplementalservice:1.0`
    * `curl localhost:3001/api/v1/1`

## Run it all together locally with Docker compose!

* Of note, need to expose ports externally at the web front-end calls them
    * Can't lock it down to internal networking when the browser does the calls
    * Am able to lock down postgresql database, so that's done
* Check the following urls:
    * (aggregratorService)[http://localhost:7777/ping]
    * (supplementalService)[http://localhost:3001/api/v1/1]
    * (dashboard-api)[http://localhost:8080/api/v1/condenser]
    * (dashboard-web)[http://localhost:3000]

## Parameterize web URLs and Health Checks

Essentially, everything is hard-coded for localhost:XXXX.
We need to make all of these services use an environment variable instead for these variables.

Additional, good time to add health checks to all the APIs for Kubernetes to use later. All should be a /health or /api/v1/health endpoint.

### Changes to aggregatorService

Luckily, api/v1/ping already exists. For consistency sake,
best to add a api/v1/health endpoint.

Since aggregatorService's only real dependency on localhost is related to CORS,
pretty easy.

Add the following to the main function in `main.go`:
```
    frontendHostname := os.Getenv("FRONTENDHOSTNAME")
	frontendPort := os.Getenv("FRONTENDPORT")

	// Defaults for dev environment
	if frontendHostname == "" {
		frontendHostname = "localhost"
	}
	if frontendPort == "" {
		frontendPort = "3000"
	}
```
Be sure to edit the CORS hostname variable too!
`"http://"+frontendHostname+":"+frontendPort`

Lastly, update docker-compose to have these environment variables and health check defined there.

### Changes to supplementalService

Super easy to add a healthcheck API endpoint.
Add the following to api.js:
```
// Health
router.get("/health", (req,res) => {
  res.status(200);
  res.send("OK");
})
```

For the environment variables, pretty straight forward.
```
// Pull in environment variables
const HOSTNAME = process.env.HOSTNAME || "localhost";
const PORT = process.env.PORT || 3001;
```
Be sure to update the server.listen() function to use these variables now.

### Changes to dashboard-api

Pretty easy for the healthcheck, add the following to src/main/java/com/flatironschool/dashboard/controller.java:
```
    @GetMapping("/health")
    public String healthCheck() {
        return "OK";
    }
```

Something different than the other options is the need for a readiness check.
As opposed to the other services, none of them "rely" on anything else, so being healthy = being ready for traffic.
For the dashboard-api, this is not the case. 

Same place as /health, add in /ready.
```
@GetMapping("/ready")
    public ResponseEntity readyCheck() {
        try {
            // Ensure data is pre-populated correctly
            if (getAllCondensers().iterator().hasNext()) {
                return new ResponseEntity(HttpStatus.OK);
            }
        } catch (Exception e) {
            return new ResponseEntity(HttpStatus.SERVICE_UNAVAILABLE);
        }
        // Not connected to DB yet, return 503
        return new ResponseEntity(HttpStatus.SERVICE_UNAVAILABLE);
    }
```

Environment variable wise, not so simple as we have both CORS, database info, and spring boot itself.

Let's start with the database info.
Add the following to MCMSDataSourceConfig.java:
```
    // the part after the colon is defaults
    @Value("${DATABASE_HOSTNAME:localhost}")
    private String database_hostname;
    @Value("${DATABASE_PORT:5432}")
    private String database_port;
    @Value("${DATABASE_NAME:mcmsdb}")
    private String database_name;
    @Value("${DATABASE_USER:mcmsuser}")
    private String database_user;
    @Value("${DATABASE_PASSWORD:mcmsuser123!}")
    private String database_password;
```

Be sure to import the `@Value` annotation and then update getDataSource() to use these values now.

Looking into it, don't even need the flyway.conf file, so comment that out of the Dockerfile.

On to the CORS issues: (it's a pain)[https://stackoverflow.com/questions/42874351/spring-boot-enabling-cors-by-application-properties].

I added a new file under the config folder named WebConfig.
This sets global CORS values as well as allows import of environment variables.

### Changes to dashboard-web

Last one!
Health check is easy, just see if the nginx container is running or not at root.
No need for explicit /health api endpoint.
No need for ready checks either as React can handle things being a little slow to spin up and be query-able.

Parameterizing-wise, this one is the main integrator,
so naturally it has A LOT of parameters required.
Additional, React Front-ends end up being static websites,
so this is actually a pain.

The trick here is create a `env.js` file that defines all the environment variables and places them in window.env.X,
then import the script into your index.html file.
Most importantly, change the docker entrypoint to run the a script to update
the `env.js` file with the actually environment variables.
Finally, you can now read the variables from the window.env.X.

The way I implemented it means there is no "dev" instance of this, only "prod".










## Configure and Run Jenkins

From here on out, things get interesting.

## Run Pre-reqs.sh

`./pre-reqs.sh`

The script does the following:

- Install Kapp-Controller
- Prepare a secret `memberlist` and cofigure kubelet with `strictARP: true` for MetalLB
- Create Jenkins Namespace and Install Jenkins
- Create ~/.kube/config-test for usage inside Jenkins
- Install Harbor and credentials

## After Pre-Reqs

- Upload `~/.kube/config-test` as a secret file in Jenkins
- Configure harbor's nip.io domain name to be forwarded to appropriate k8s service internally
    - `kubectl edit cm/coredns -n kube-system`
    - Above the line `cache 30`, add the following line:
    ```
        rewrite name harbor.127.0.0.1.nip.io my-service.harbor.svc.cluster.local
    ```
- Exec into the KinD docker container and append the following to `/etc/containerd/config.toml`
    - ```
        [plugins."io.containerd.grpc.v1.cri".registry]
          [plugins."io.containerd.grpc.v1.cri".registry.configs]
            [plugins."io.containerd.grpc.v1.cri".registry.configs."harbor.127.0.0.1.nip.io:8443".tls]
              insecure_skip_verify = true
      ```
    - `systemctl restart containerd` afterwards

## After the "After Pre-Reqs"

In a separate terminal, run `kubectl port-forward svc/jenkins -n jenkins 8081:8080`.
Go to https://jenkins.127.0.0.1:8081 to browse the Jenkins UI.

Click the `capstone` project and click `Build Now`.

Watch the magic as the pipeline runs!

## Mid-Jenkins Pause Items to do

- Firstly, check that Ingress+Metallb is working correctly
    - `kubectl get svc -n ingress-nginx`, should see the controller has an External-IP
-Port forward the ingress controller locally
    - `kubectl port-forward svc/ingress-nginx-controller -n ingress-nginx 8080:80 8443:443`
- Navigate the Harbor UI and add a project called `my-repo`
    - https://harbor.127.0.0.1.nip.io:8443
- Run `harborPullSecretSetup.sh`
- Exec into the kind container and run `kubectl port-forward svc/ingress-nginx-controller -n ingress-nginx 8080:80 8443:443`
    - If you don't do the above two steps, you'll get ImageBackOffErrors or worse

## After Jenkins Build

Hopefully, you have a properly populated cluster now with the following installed:

- Metallb
- Ingress-nginx
- cert-manager
- Harbor
- Containers for the moisture farm were made and pushed to Harbor
- Moisture farm apps were deployed in k8s