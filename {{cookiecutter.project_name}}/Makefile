.PHONY: install
install: ## Install the environment and install the pre-commit hooks
	@echo "🚀 Creating virtual environment using PDM"
	@pdm install
	@pdm run pre-commit install

.PHONY: check
check: ## Run code quality tools.
	@echo "🚀 Checking pdm lock file consistency with 'pyproject.toml': Running pdm lock --check"
	@pdm lock --check
	@echo "🚀 Linting code: Running pre-commit"
	@pdm run pre-commit run -a
	@echo "🚀 Static type checking: Running mypy"
	@pdm run mypy
{%- if cookiecutter.deptry == 'y' %}
	@echo "🚀 Checking for obsolete dependencies: Running deptry"
	@pdm run deptry .
{%- endif %}

.PHONY: test
test: ## Test the code with pytest
	@echo "🚀 Testing code: Running pytest"
{%- if cookiecutter.codecov == "y"%}
	@pdm run pytest --cov --cov-config=pyproject.toml --cov-report=xml
{%- else %}
	@pdm run pytest --doctest-modules
{%- endif%}

.PHONY: build
build: clean-build ## Build wheel file
	@echo "🚀 Creating wheel file"
	@pdm build

.PHONY: clean-build
clean-build: ## clean build artifacts
	@rm -rf dist

{%- if cookiecutter.publish_to == "pypi"%}

.PHONY: publish
publish: ## publish a release to pypi.
	@echo "🚀 Publishing."
	@pdm publish --password $PYPI_TOKEN

.PHONY: build-and-publish
build-and-publish: build publish ## Build and publish.
{%- elif cookiecutter.publish_to == "artifactory" %}

.PHONY: publish
publish: ## Publish to the Artifactory repository using PDM. Requires ARTIFACTORY_TOKEN to be set.
	@echo "🚀 Publishing: Dry run."
	@pdm config repositories.artifactory $(ARTIFACTORY_URL)
	@pdm publish --repository artifactory --username $(ARTIFACTORY_USERNAME) --password $(ARTIFACTORY_PASSWORD) --dry-run
	@echo "🚀 Publishing."
	@pdm publish --repository artifactory --username $(ARTIFACTORY_USERNAME) --password $(ARTIFACTORY_PASSWORD)

.PHONY: build-and-publish
build-and-publish: build publish ## Build and publish.
{%- endif%}

{%- if cookiecutter.mkdocs == "y" %}

.PHONY: docs-test
docs-test: ## Test if documentation can be built without warnings or errors
	@pdm run mkdocs build -s

.PHONY: docs
docs: ## Build and serve the documentation
	@pdm run mkdocs serve

{%- endif %}

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
