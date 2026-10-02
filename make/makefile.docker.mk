SHELL = /bin/bash

ghcr_registry ?= ghcr.io/leolani

# Only override the Dockerfile's own `ARG base_image` default when the component
# (or the command line) actually asked for a different base. Passing an empty
# --build-arg is not the same as passing none: BuildKit would set the ARG to the
# empty string and `FROM ${base_image}` would fail to resolve.
base_image_arg = $(if $(strip $(docker_base)),--build-arg base_image=$(strip $(docker_base)),)

.PHONY: docker-ghcr-build
docker-ghcr-build:
	DOCKER_BUILDKIT=1 docker build \
		--build-context leolani=${project_repo} \
		${base_image_arg} \
		-t ${ghcr_registry}/${project_name}:${docker_version} \
		-t ${ghcr_registry}/${project_name}:latest \
		.

.PHONY: docker-ghcr-push
docker-ghcr-push: docker-ghcr-build
	docker push ${ghcr_registry}/${project_name}:${docker_version}
	docker push ${ghcr_registry}/${project_name}:latest
