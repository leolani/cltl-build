SHELL=/bin/bash

project_root ?= $(realpath ..)
project_components ?=


git_remote ?= https://github.com/leolani


.PHONY: git-update
git-update:
	git submodule update --remote --force --recursive


.PHONY: git-local
git-local:
	@for component in $(notdir $(project_components)); do \
		git submodule set-url -- $$component $(project_root)/$$component; \
	done

.PHONY: git-remote
git-remote:
	@for component in $(notdir $(project_components)); do \
		git submodule set-url -- $$component $(git_remote)/$$component; \
	done
