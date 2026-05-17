SHELL = /bin/bash

project_name ?= $(notdir $(realpath .))
project_version ?= $(shell cat VERSION)
docker_version ?= $(shell cat VERSION | tr '+!' '--')


clean: py-clean

install: docker

.PHONY: docker
docker:
	DOCKER_BUILDKIT=1 docker build -t cltl/${project_name}:${docker_version} -t cltl/${project_name}:latest .