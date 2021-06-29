SHELL=/bin/bash

project_root ?= $(realpath ..)
project_name ?= $(notdir $(realpath .))
project_version ?= $(shell cat version.txt)
project_repo ?= ${project_root}/cltl-requirements/leolani
project_mirror ?= ${project_root}/cltl-requirements/mirror
# Add required components
project_dependencies ?=


$(info Project $(project_name), version: $(project_version), in $(project_root))


# Include help comments using the '##' prefix:
## .
## -------------------------------------
## Basic targets for building projects
## -------------------------------------
## .
.PHONY: help
help:  ## Show this help
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)


.DEFAULT_GOAL := install


# Implicit rules that are specified later or by an included makefile.

.PHONY: depend
depend:
# Discover dependencies of this project.
# This will create a makefile.d containing this project as target
# and the dependencies defined in project_dependencies as prerequisites.

.PHONY: clean
clean: base-clean
# Clean build artifacts and remove discovered dependencies.

.PHONY: touch-version
touch-version:
# Reset the version timestamp to avoid version increment.

.PHONY: version
version: version.txt  ## Update the project version in the version.txt file
# Update the project version.
# This will increment the minor version if changes in this project
# or on of it's dependencies are detected.

version.txt: $(addsuffix /version.txt, $(project_dependencies))
# The version is stored and retrieved from the version.txt file.

.PHONY: version
build: version.txt
# Build the project.

.PHONY: test
test: build
# Run tests in the project.

.PHONY: install
install: test
# Install the build artifacts to a (local) repository.


# Explicit rules

.PHONY: base-clean
base-clean:  ## Remove dependency rules created by this makefile
	@rm -rf makefile.d

version.txt:  # Perform the actual project version update.
	$(info Update version of ${project_root}/$(project_name))
	@cat version.txt | awk -F. -v OFS=. '{$$NF++;print}' > version.increment
	@mv version.increment version.txt

touch-version:  ## Reset the version timestamp to avoid increment
	touch version.txt

depend:  ## Discover dependencies of this project
ifdef project_dependencies
	echo ${project_root}/$(project_name): $(project_dependencies) > makefile.d
else
	touch makefile.d
endif
