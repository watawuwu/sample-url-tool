# Option
#===============================================================
LOG_LEVEL := debug
APP_ARGS := "foo%20bar"
.DEFAULT_GOAL := run

# Environment
#===============================================================
export RUST_LOG=url=$(LOG_LEVEL)

# Task
#===============================================================
run:
	cargo +beta run $(APP_ARGS)

test:
	cargo +beta test
