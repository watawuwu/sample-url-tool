# Const
#===============================================================
_name := url

# Option
#===============================================================
SHELL                   := /bin/bash
LOG_LEVEL               := debug
LOG                     := $(shell echo '$(_name)' | tr - _)=$(LOG_LEVEL)
PREFIX                  := $(HOME)/.cargo
APP_ARGS                := "foo%20bar"
CARGO_VERSION           := stable
CARGO_OPTIONS           :=
CARGO_SUB_OPTIONS       :=
CARGO_COMMAND           := cargo +$(CARGO_VERSION) $(CARGO_OPTIONS)

# Environment
#===============================================================
export RUST_LOG=$(LOG)
export RUST_BACKTRACE=1

# Task
#===============================================================
run: ## Execute a main.rs
	$(CARGO_COMMAND) run $(CARGO_SUB_OPTIONS) $(APP_ARGS)

test: ## Run the tests
	$(CARGO_COMMAND) test $(CARGO_SUB_OPTIONS) -- --nocapture

check: ## Check syntax, but don't build object files
	$(CARGO_COMMAND) check $(CARGO_SUB_OPTIONS)

build: ## Build all project
	$(CARGO_COMMAND) build $(CARGO_SUB_OPTIONS)

release-build: lint ## Build all project
	$(MAKE) build CARGO_SUB_OPTIONS="--release"

clean: ## Remove the target directory
	$(CARGO_COMMAND) clean

install: ## Install to $(PREFIX) directory
	$(CARGO_COMMAND) install --force --root $(PREFIX) --path .

fmt: ## Run fmt
	$(CARGO_COMMAND) fmt

clippy: ## Run clippy
	$(CARGO_COMMAND) clippy

lint: fmt clippy ## Run fmt and clippy

help: ## Print help
	echo "Usage: make [task]\n\nTasks:"
	perl -nle 'printf("    \033[33m%-20s\033[0m %s\n",$$1,$$2) if /^([a-zA-Z_-]*?):(?:.+?## )?(.*?)$$/' $(MAKEFILE_LIST)

# Config
#===============================================================
.SILENT: help
# If you want `Target` instead of `Task`, you can avoid it by using dot(.) and slash(/)
# ex) node_modules: => ./node_modules:
.PHONY: $(shell egrep -o '^(\._)?[a-z_-]+:' $(MAKEFILE_LIST) | sed 's/://')

.DEFAULT_GOAL := build
