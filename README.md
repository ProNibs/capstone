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

* Of note, need to expose 


