SHELL=/bin/bash


.PHONY: git-status
git-status:
	git submodule foreach 'git status'


.PHONY: git-reset-version
git-reset-version:
	-git submodule foreach 'git checkout -- VERSION'


.PHONY: git-update
git-update: git-reset-version
	git submodule update --remote --recursive


.PHONY: git-pull
git-pull: git-reset-version
	git pull --recurse-submodules --ff-only
