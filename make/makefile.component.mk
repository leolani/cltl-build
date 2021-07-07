SHELL = /bin/bash

project_name ?= $(notdir $(realpath .))
project_version ?= $(shell cat version.txt)


clean: py-clean

install: docker

.PHONY: docker
docker:
	DOCKER_BUILDKIT=1 docker build -t cltl/${project_name}:${project_version} .