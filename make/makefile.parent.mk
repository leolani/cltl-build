SHELL=/bin/bash

export project_root=$(realpath .)
project_name = "app"
project_version = $(shell cat version.txt)

components = $(addprefix ${project_root}/, \
		cltl-requirements \
		cltl-combot \
		cltl-app \
		cltl-app-component)

dependencies = $(addsuffix /makefile.d, $(components))


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
build: $(components)

.PHONY: $(components)
$(components):
	$(MAKE) --directory=$@ $(target)

.PHONY: depend
depend: $(dependencies)

$(dependencies):
	$(MAKE) --directory=$(dir $@) depend

include $(dependencies)

include makefile.git.mk
