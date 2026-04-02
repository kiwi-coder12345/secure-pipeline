# Secure CI Pipeline — Spring Pet Clinic on JFrog

A demonstration of a secure DevSecOps CI pipeline for building and packaging the [Spring Pet Clinic](https://github.com/spring-projects/spring-petclinic) Java application as a Docker image, with all dependencies resolved securely through JFrog Artifactory.

---

## Pipeline Overview

The GitHub Actions pipeline performs the following steps on every push to `main`:

1. **Checkout** — pulls the Spring Pet Clinic source code directly from the official repo
2. **Compile** — compiles the Java source code via Maven, routing all dependencies through JFrog Artifactory
3. **Test** — runs the full test suite
4. **Package** — builds a runnable JAR
5. **Docker Build** — packages the JAR into a Docker image using a multi-stage Dockerfile
6. **Docker Push** — pushes the image to JFrog Artifactory's Docker registry

All Maven dependencies are resolved through JFrog Artifactory (proxying Maven Central), ensuring secure, auditable dependency resolution.

---

## Repository Structure

```
.
├── Dockerfile                        # Multi-stage Docker build
├── settings.xml                      # Maven settings routing deps through JFrog
├── .github/
│   └── workflows/
│       └── pipeline.yml              # GitHub Actions CI pipeline
└── README.md
```

---

## Prerequisites

- A [JFrog Platform](https://jfrog.com/start-free) trial account with:
  - A **Remote Maven repository** keyed `maven-central-remote`
  - A **Local Docker repository** keyed `docker-local`
- GitHub repository secrets set:
  - `JFROG_URL` — your JFrog instance domain e.g. `yourname.jfrog.io`
  - `JFROG_USERNAME` — your JFrog username/email
  - `JFROG_TOKEN` — your JFrog access token

---

## Running the Docker Image Locally

Pull and run the image from JFrog Artifactory:

```bash
docker login yourname.jfrog.io -u YOUR_USERNAME -p YOUR_TOKEN

docker pull yourname.jfrog.io/docker-local/petclinic:latest

docker run -p 8080:8080 yourname.jfrog.io/docker-local/petclinic:latest
```

Then open your browser at [http://localhost:8080](http://localhost:8080).

---

## Security Highlights

- All build dependencies are proxied through JFrog Artifactory — no direct internet access to Maven Central
- Docker image is pushed to a private JFrog registry — not Docker Hub
- Credentials are stored as encrypted GitHub Actions secrets — never hardcoded
- Multi-stage Docker build minimises the final image surface area
