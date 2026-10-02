SHELL = /bin/bash

project_name ?= $(notdir $(realpath .))
project_version ?= $(shell cat VERSION)
docker_version ?= $(shell cat VERSION | tr '+!' '--')
# Deliberately empty: each component's Dockerfile names its own base through
# `ARG base_image`, and makefile.docker.mk passes --build-arg only when this is
# set. A default here would silently override every one of those, which is how
# the components that had already been moved to cltl-base-slim kept being built
# on the 4 GB full base. Set it on the command line to build one against another
# base, e.g. `make docker-ghcr-build docker_base=ghcr.io/leolani/cltl-base:latest`.
docker_base ?=


clean: py-clean