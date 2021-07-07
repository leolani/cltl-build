SHELL=/bin/bash

project_root ?= $(realpath ..)
project_name ?= $(notdir $(realpath .))
project_version ?= $(shell cat version.txt)
project_repo ?= ${project_root}/cltl-requirements/leolani
project_mirror ?= ${project_root}/cltl-requirements/mirror
# Add required components
project_dependencies ?=


$(info Project $(project_name), version: $(project_version), in $(project_root))


# Implicit rules
.PHONY: depend
depend:

.PHONY: clean
clean: base-clean

.PHONY: touch-version
touch-version:

.PHONY: version
version: version.txt

version.txt: $(addsuffix /version.txt, $(project_dependencies))

.PHONY: version
build: version.txt

.PHONY: test
test: build

.PHONY: install
install:

# Explicit rules
.PHONY: base-clean
base-clean:
	@rm -rf makefile.d

version.txt:
	$(info Update version of ${project_root}/$(project_name))
	@cat version.txt | awk -F. -v OFS=. '{$$NF++;print}' > version.increment
	@mv version.increment version.txt

touch-version:
	touch version.txt

depend:
ifdef project_dependencies
	echo ${project_root}/$(project_name): $(project_dependencies) > makefile.d
else
	touch makefile.d
endif
