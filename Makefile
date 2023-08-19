#################################################################################
# GLOBALS                                                                       #
#################################################################################
ENVNAME := $(shell poetry env info --path)
VENV := $(ENVNAME)/bin

PROJECT_NAME = anomaly_detection
PYTHON_INTERPRETER = $(VENV)/python


#################################################################################
# COMMANDS                                                                      #
#################################################################################
.PHONY: run
run:
	$(PYTHON_INTERPRETER) -m kedro run --env local

.PHONY: run_prod
run_prod:
	$(PYTHON_INTERPRETER) -m kedro run --env prod

.PHONY: mlflow
mlflow:
	$(PYTHON_INTERPRETER) -m kedro mlflow ui

.PHONY: viz
viz:
	$(PYTHON_INTERPRETER) -m kedro viz

.PHONY: clean
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete

	rm -rf .*_cache
	rm -rf logs
	rm -rf site

	rm -rf data/02_intermediate/*
	rm -rf data/03_primary/*
	rm -rf data/04_feature/*
	rm -rf data/05_model_input/*
	rm -rf data/06_model/*
	rm -rf data/07_model_output/*
	rm -rf data/08_reporting/*

.PHONY: test
test:
	$(PYTHON_INTERPRETER) -m pytest src/tests
	$(VENV)/coverage report

.PHONY: lint
lint:
	git add --intent-to-add .
	. $(VENV)/activate; $(VENV)/pre-commit run --all-files

#################################################################################
# DOCS
#################################################################################
.PHONY: build_html_docs
build_html_docs: generate_api_documentation
	$(VENV)/sphinx-build -M html ./docs ./docs/build

.PHONY: build_pdf_docs
build_pdf_docs: generate_api_documentation
	$(VENV)/sphinx-build -M latexpdf ./docs ./docs/build

.PHONY: serve_docs
serve_docs: generate_api_documentation
	$(VENV)/sphinx-autobuild ./docs ./docs/build/html

.PHONY: generate_api_documentation
generate_api_documentation:
	$(VENV)/sphinx-apidoc -o docs/source/code ./src/$(PROJECT_NAME)

#################################################################################
# SETUP
#################################################################################

.PHONY: install
install: install_tools install_dependencies
	$(MAKE) install_precommit
	$(MAKE) install_kernel
	@echo "Initilize direnv..."
	direnv allow

.PHONY: install_tools
install_tools:
	@echo "Install dev tools..."
	git init -q
	@sh ./scripts/install_tools.sh

.PHONY: install_dependencies
install_dependencies: install_tools
	@echo "Install dependencies..."
	@sh ./scripts/install_dependencies.sh

.PHONY: install_precommit
install_precommit:
	@echo "Install pre-commit hooks..."
	git init -q
	$(VENV)/pre-commit install
	$(VENV)/pre-commit install-hooks
	$(VENV)/pre-commit install --hook-type commit-msg

.PHONY: install_kernel
install_kernel:
	@echo "Install ipython kernel..."
	$(VENV)/python -m ipykernel install --user --name $(PROJECT_NAME)
