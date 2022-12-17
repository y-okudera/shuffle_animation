.PHONY: help
help: ## Show this usage
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: setup
setup: ## Install fvm.
	dart pub global activate fvm
	npm install -g npm@8.18.0

.PHONY: fvm-install
fvm-install: ## Execute fvm install.
	fvm install

.PHONY: build-runner
build-runner: ## Generate code dynamically with annotations.
	make clean
	make pub-get
	fvm flutter packages pub run build_runner build --delete-conflicting-outputs

.PHONY: pub-get
pub-get: ## pub get
	fvm flutter packages pub get

.PHONY: clean
clean: ## Clean
	fvm flutter clean

.PHONY: format
format: ## Formatting
	fvm flutter format lib/

.PHONY: run-dev
run-dev: ## Run development app.
	fvm flutter run --target lib/main.dart
