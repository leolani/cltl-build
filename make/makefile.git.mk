remote ?= https://github.com/leolani

.PHONY: git-update
git-update:
	git submodule update $$component $(project_root)/$$component


.PHONY: git-local
git-local:
	@for component in $(notdir $(components)); do \
		git submodule set-url -- $$component $(project_root)/$$component; \
	done

.PHONY: git-remote
git-remote:
	@for component in $(notdir $(components)); do \
		git submodule set-url -- $$component $(remote)/$$component; \
	done
