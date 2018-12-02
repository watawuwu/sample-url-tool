# Option
#===============================================================
LOG_LEVEL := debug
APP_ARGS := "foo%20bar"
.DEFAULT_GOAL := run
SHELL := /bin/bash
OPTION := ""
BUILDER := cargo

# Environment
#===============================================================
export RUST_LOG=url=$(LOG_LEVEL)

# Task
#===============================================================
run:
	$(BUILDER) +beta run $(OPTION) $(APP_ARGS)

test:
	$(BUILDER) +beta test $(OPTION)

build:
	$(BUILDER) +beta build $(OPTION)


# load-cargo-config:
# 	source $(HOME)/.cargo/env
