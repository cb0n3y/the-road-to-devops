# Docker

> *"Containers changed how applications are built, shipped, and deployed. Docker is the first major step into modern DevOps."*

## Overview

This section documents my Docker learning journey as part of **The Road to DevOps**.

The objective is not only to learn Docker commands, but to understand how containers work internally, how images are built, how networking and storage behave, and how Docker integrates into modern CI/CD pipelines and Kubernetes environments.

Everything in this directory is based on hands-on labs, personal experiments, and real-world scenarios.

---

## Learning Goals

* Understand containerization fundamentals
* Learn Docker architecture
* Build custom Docker images
* Create efficient Dockerfiles
* Manage volumes and persistent storage
* Configure Docker networking
* Use Docker Compose for multi-container applications
* Secure container images
* Optimize image size
* Publish images to Docker registries
* Debug running containers
* Prepare for Kubernetes by understanding container fundamentals

---

## Topics Covered

### Docker Fundamentals

* Docker Architecture
* Images
* Containers
* Registries
* Docker Hub
* Container Lifecycle

---

### Docker CLI

* Images
* Containers
* Networks
* Volumes
* Logs
* Exec
* Inspect
* Stats
* System Cleanup

---

### Docker Images

* Building Images
* Image Layers
* Multi-stage Builds
* Image Optimization
* Image Tagging
* Best Practices

---

### Dockerfile

Topics include:

* FROM
* RUN
* COPY
* ADD
* CMD
* ENTRYPOINT
* ENV
* ARG
* EXPOSE
* WORKDIR
* USER
* HEALTHCHECK
* LABEL

---

### Docker Networking

* Bridge
* Host
* None
* Custom Networks
* DNS Resolution
* Service Discovery

---

### Docker Storage

* Volumes
* Bind Mounts
* tmpfs
* Persistent Data

---

### Docker Compose

* compose.yaml
* Services
* Networks
* Volumes
* Environment Variables
* Dependencies
* Healthchecks

---

### Security

* Non-root Containers
* Image Scanning
* Secrets
* Least Privilege
* Read-only Filesystems

---

### Debugging

* docker logs
* docker exec
* docker inspect
* docker stats
* docker events

---

### Registry

* Docker Hub
* Private Registries
* Harbor

---

## Hands-on Projects

This repository includes practical exercises such as:

* Building custom Nginx images
* Python Flask containers
* Multi-container applications
* Reverse Proxy with Nginx
* Private Harbor Registry
* Container Networking Labs
* Volume and Persistence Labs
* Docker Compose deployments

---

## Course

This learning path follows:

**Docker Mastery: with Kubernetes + Swarm from a Docker Captain**

The concepts learned here will later be used throughout the Kubernetes, CI/CD, GitOps, and Observability sections of this repository.

---

## Repository Structure

```text
docker/
├── fundamentals/
├── dockerfiles/
├── images/
├── containers/
├── networking/
├── volumes/
├── compose/
├── security/
├── registry/
├── projects/
└── README.md
```

---

## Progress

* [ ] Docker Fundamentals
* [ ] Docker CLI
* [ ] Docker Images
* [ ] Dockerfile
* [ ] Docker Networking
* [ ] Docker Storage
* [ ] Docker Compose
* [ ] Security
* [ ] Private Registry
* [ ] Hands-on Projects

---

## Next Step

Once Docker fundamentals are complete, the next stage of the roadmap is **Kubernetes (CKA)**, where these container concepts become the foundation for orchestration, deployments, scaling, and production workloads.
