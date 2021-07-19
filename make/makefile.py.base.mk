project_name ?= $(notdir $(realpath .))
project_repo ?= ${project_root}/cltl-requirements/leolani
project_mirror ?= ${project_root}/cltl-requirements/mirror


.PHONY: py-clean
py-clean:
	$(info Clean $(project_name))
	@rm -rf venv dist build *.egg-info

venv:
	python -m venv venv
	source venv/bin/activate; \
		pip install -r requirements.txt --no-index \
			--find-links="$(project_mirror)" --find-links="$(project_repo)"; \
		deactivate

build: py-install

test:
	source venv/bin/activate; \
		python -m unittest; \
		deactivate

.PHONY: py-upgrade
py-upgrade: venv
	source venv/bin/activate; \
		pip install -r requirements.txt --upgrade --no-index \
				--find-links="$(project_mirror)" --find-links="$(project_repo)"; \
		deactivate

.PHONY: dist
dist: venv py-upgrade
	$(info Create distribution for $(project_name))

	source venv/bin/activate; \
		python setup.py sdist; \
		deactivate

.PHONY: py-install
py-install: dist
	$(info Install $(project_name))
	@rm -rf $(project_repo)/$(project_name)-{0..9}*.tar.gz
	@cp dist/*.tar.gz $(project_repo)
