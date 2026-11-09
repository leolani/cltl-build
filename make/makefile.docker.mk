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

# Multi-platform build, pushed straight to the registry. A plain `docker build`
# produces an image for the host architecture only, so images built on an
# aarch64 machine will not run on amd64 cloud hosts. A multi-platform result
# cannot be loaded into the local image store, hence --push; the local
# `docker-ghcr-build` target is unchanged because the integration tests need
# the images locally. The base image must be pushed multi-platform first
# (`make -C cltl-requirements docker-ghcr-push-multiarch`), since the component
# build pulls it from the registry for each platform.
docker_platforms ?= linux/amd64,linux/arm64

.PHONY: docker-ghcr-push-multiarch
docker-ghcr-push-multiarch:
	DOCKER_BUILDKIT=1 docker buildx build \
		--platform ${docker_platforms} \
		--build-context leolani=${project_repo} \
		${base_image_arg} \
		-t ${ghcr_registry}/${project_name}:${docker_version} \
		-t ${ghcr_registry}/${project_name}:latest \
		--push \
		.
