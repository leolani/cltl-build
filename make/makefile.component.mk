SHELL = /bin/bash

project_name ?= $(notdir $(realpath .))
project_version ?= $(shell cat VERSION)
docker_version ?= $(shell cat VERSION | tr '+!' '--')
docker_base ?= ghcr.io/leolani/cltl-base:latest


clean: py-clean