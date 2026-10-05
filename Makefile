# Docker Compose v2 plugin (`docker compose`, not the old `docker-compose`)
DOCKER_COMPOSE := docker compose

.PHONY: build run stop test clean helm-lint helm-template

CHART := helm/two-tier-flask-app

# Build target
build:
	$(DOCKER_COMPOSE) build

# Run target
run:
	$(DOCKER_COMPOSE) up -d

# Stop target
stop:
	$(DOCKER_COMPOSE) down

# Test target (needs: pip install -r requirements-dev.txt)
test:
	python -m pytest

# Clean target
clean: stop
	$(DOCKER_COMPOSE) rm -f
	docker system prune -f

# Helm chart checks (same as the CI helm-lint job, minus kubeconform)
helm-lint:
	for v in values-kubeadm.yaml values-eks.yaml values-ci.yaml; do helm lint --strict $(CHART) -f $(CHART)/$$v || exit 1; done

# Render the manifests for an overlay: make helm-template VALUES=values-eks.yaml
VALUES ?= values-kubeadm.yaml
helm-template:
	helm template two-tier-flask-app $(CHART) -n two-tier -f $(CHART)/$(VALUES)
