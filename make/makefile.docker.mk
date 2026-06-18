SHELL = /bin/bash

ghcr_registry ?= ghcr.io/leolani

.PHONY: docker-ghcr-build
docker-ghcr-build:
	DOCKER_BUILDKIT=1 docker build \
		--build-context leolani=${project_repo} \
		--build-arg base_image=${docker_base} \
		-t ${ghcr_registry}/${project_name}:${docker_version} \
		-t ${ghcr_registry}/${project_name}:latest \
		.

.PHONY: docker-ghcr-push
docker-ghcr-push: docker-ghcr-build
	docker push ${ghcr_registry}/${project_name}:${docker_version}
	docker push ${ghcr_registry}/${project_name}:latest
