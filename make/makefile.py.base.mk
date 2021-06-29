project_name ?= $(notdir $(realpath .))
project_repo ?= ${project_root}/cltl-requirements/leolani
project_mirror ?= ${project_root}/cltl-requirements/mirror

## .
## ---------------------------------------------------
## Python related targets for setup and package builds
## ---------------------------------------------------
## .



.PHONY: py-clean
py-clean:  ## Clean Python build artifacts
	$(info Clean $(project_name))
	@rm -rf venv dist build *.egg-info

venv:  ## Setup a virtual environment for Python
	python -m venv venv
	source venv/bin/activate; \
		pip install -r requirements.txt --no-index \
			--find-links="$(project_mirror)" --find-links="$(project_repo)"; \
		deactivate

build: dist  ## Build Python packages for the project

test:  ## Run Python unit tests
	source venv/bin/activate; \
		python -m unittest; \
		deactivate

dist: venv    ## Create a source distribution for the project
	$(info Create distribution for $(project_name))
	source venv/bin/activate; \
		python setup.py sdist; \
		deactivate

py-install: dist  ## Copy the source distribution to the local project repository
	$(info Install $(project_name))
	@rm -rf $(project_repo)/$(project_name).{0..9}*.tar.gz
	@cp dist/*.tar.gz $(project_repo)
