SHELL=/bin/bash

export project_root ?= $(realpath .)
project_name ?= "app"
project_version ?= $(shell cat version.txt)

project_components ?=


dependencies ?= $(addsuffix /makefile.d, $(project_components))


target ?= install
.DEFAULT_GOAL := build


$(info Run $(target) for $(project_name), version: $(project_version), in $(project_root))


.PHONY: clean
clean:
	$(MAKE) target=clean

.PHONY: install
install:
	$(MAKE) target=install

.PHONY: build
build: $(project_components)

.PHONY: $(project_components)
$(project_components):
	$(MAKE) --directory=$@ $(target)

.PHONY: depend
depend: $(dependencies)

$(dependencies):
	$(MAKE) --directory=$(dir $@) depend


include $(dependencies)
