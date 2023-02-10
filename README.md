## Simple Kubernetes Site (SKS)

This repo contains a Makefile for building a very minimal Kubernetes cluster in AWS.

### Requirements

* Node.js version: 12.22.9
* Npm version: 8.19.3
* Next.js version: 13.1.6
* React: 18.2.0
* React-Dom version: 18.2.0

You must also have an AWS ECS registry setup to push the Docker image of the app to. You must set the registry in the ```.config``` file under the ```ECS_REGISTRY``` variable.

### Running the App Locally

```make run-app-locally```

### Containerizing the App

```make push-container```

### Deploying to Kubernetes Cluster

```make deploy-dev```