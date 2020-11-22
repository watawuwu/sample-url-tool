# Const
#===============================================================
name := url

# Option
#===============================================================
SHELL                   := /bin/bash
LOG_LEVEL               := debug
LOG                     := $(name)=$(LOG_LEVEL)
PREFIX                  := $(HOME)/.cargo
APP_ARGS                := "foo%20bar"
CARGO_SUB_OPTIONS       :=

# Environment
#===============================================================
export RUST_LOG=$(LOG)
export RUST_BACKTRACE=1

# Task
#===============================================================
run: ## Execute a main.rs
	cargo run $(CARGO_SUB_OPTIONS) $(APP_ARGS)

test: ## Run the tests
	cargo test $(CARGO_SUB_OPTIONS) -- --nocapture

check: ## Check syntax, but don't build object files
	cargo check $(CARGO_SUB_OPTIONS)

build: ## Build all project
	cargo build $(CARGO_SUB_OPTIONS)

release-build: ## Build all project
	$(MAKE) build CARGO_SUB_OPTIONS="--release"

clean: ## Remove the target directory
	cargo clean

install: ## Install to $(PREFIX) directory
	cargo install --force --root $(PREFIX) --path .

fmt: ## Run fmt
	cargo fmt

clippy: ## Run clippy
	cargo clippy

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
