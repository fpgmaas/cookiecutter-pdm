.PHONY: bake
bake: ## bake without inputs and overwrite if exists.
	@cookiecutter --no-input . --overwrite-if-exists

.PHONY: bake-with-inputs
bake-with-inputs: ## bake with inputs and overwrite if exists.
	@cookiecutter . --overwrite-if-exists

.PHONY: bake-and-test-deploy
bake-and-test-deploy: ## For quick publishing to cookiecutter-pdm-example to test GH Actions
	@rm -rf cookiecutter-pdm-example || true
	@cookiecutter --no-input . --overwrite-if-exists \
		author="Florian Maas" \
		email="fpgmaas@gmail.com" \
		github_author_handle=fpgmaas \
		project_name=cookiecutter-pdm-example \
		project_slug=cookiecutter_pdm_example
	@cd cookiecutter-pdm-example; pdm install && \
		git init -b main && \
		git add . && \
		pdm run pre-commit install && \
		pdm run pre-commit run -a || true && \
		git add . && \
		pdm run pre-commit run -a || true && \
		git add . && \
		git commit -m "init commit" && \
		git remote add origin git@github.com:fpgmaas/cookiecutter-pdm-example.git && \
		git push -f origin main


.PHONY: install
install: ## Install the environment
	@echo "🚀 Creating virtual environment using pyenv and PDM"
	@pdm install

.PHONY: check
check: ## Run code quality tools.
	@echo "🚀 Checking pdm lock file consistency with 'pyproject.toml': Running pdm lock --check"
	@pdm lock --check
	@echo "🚀 Linting code: Running pre-commit"
	@pdm run pre-commit run -a
	@echo "🚀 Linting with ruff"
	@pdm run ruff hooks tests cookiecutter_pdm --config pyproject.toml
	@echo "🚀 Static type checking: Running mypy"
	@pdm run mypy
	@echo "🚀 Checking for obsolete dependencies: Running deptry"
	@pdm run deptry .

.PHONY: test
test: ## Test the code with pytest.
	@echo "🚀 Testing code: Running pytest"
	@pdm run pytest --cov --cov-config=pyproject.toml --cov-report=xml tests

.PHONY: build
build: clean-build ## Build wheel file
	@echo "🚀 Creating wheel file"
	@pdm build

.PHONY: clean-build
clean-build: ## clean build artifacts
	@rm -rf dist

.PHONY: publish
publish: ## publish a release to pypi.
	@echo "🚀 Publishing."
	@pdm publish --username __token__ --password $(PYPI_TOKEN)

.PHONY: build-and-publish
build-and-publish: build publish ## Build and publish.

.PHONY: docs-test
docs-test: ## Test if documentation can be built without warnings or errors
	@mkdocs build -s

.PHONY: docs
docs: ## Build and serve the documentation
	@mkdocs serve

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
