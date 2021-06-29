SHELL=/bin/bash

project_components ?=


git_local ?=
git_remote ?= https://github.com/leolani


## .
## -------------------------------
## Version control related targets
## -------------------------------
## .


.PHONY: git-update
git-update:  ## Update the repository including all submodules from the remote
	git submodule update --remote --force --recursive


.PHONY: git-local
git-local:  ## Set the remote to local workspaces
	@for component in $(notdir $(project_components)); do \
		git submodule set-url -- $$component $(git_local)/$$component; \
	done

.PHONY: git-remote
git-remote:  ## Set the remote to the configured remote repository base
	@for component in $(notdir $(project_components)); do \
		git submodule set-url -- $$component $(git_remote)/$$component; \
	done
