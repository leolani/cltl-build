SHELL = /bin/bash

project_root ?= $(realpath ..)
project_name ?= $(notdir $(realpath .))
project_version ?= $(shell cat version.txt)
project_chart ?= demo-app

.PHONY: run
run:
	minikube start
	kubectl cluster-info
	helm install $(project_name) $(project_root)/$(project_name)/$(project_chart)
	kubectl -n kube-system describe secret \
		$(shell kubectl -n kube-system get secret | awk '/^deployment-controller-token-/{print $$1}') \
		| awk '$$1=="token:"{print $$2}' | head -n 1

.PHONY: stop
stop:
	minikube delete