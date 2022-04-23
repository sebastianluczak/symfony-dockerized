# Executables (local)
DOCKER_COMP = docker-compose

# Docker containers
PHP_CONT = $(DOCKER_COMP) exec php

# Executables
PHP      = $(PHP_CONT) php
COMPOSER = $(PHP_CONT) composer
SYMFONY  = $(PHP_CONT) bin/console

# Misc
.DEFAULT_GOAL = help
.PHONY        = help build up start down logs sh composer vendor sf cc

## —— 🎵 🐳 The Symfony-docker Makefile 🐳 🎵 ——————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker 🐳 ————————————————————————————————————————————————————————————————
build: ## Builds the Docker images
	@$(DOCKER_COMP) build --pull --no-cache

up: ## Start the docker hub in detached mode (no logs)
	@$(DOCKER_COMP) up --detach

start: build up ## Build and start the containers

down: ## Stop the docker hub
	@$(DOCKER_COMP) down --remove-orphans

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

sh: ## Connect to the PHP FPM container
	@$(PHP_CONT) sh

## —— Composer 🧙 ——————————————————————————————————————————————————————————————
composer: ## Run composer, pass the parameter "c=" to run a given command, example: make composer c='req symfony/orm-pack'
	@$(eval c ?=)
	@$(COMPOSER) $(c)

vendor: ## Install vendors according to the current composer.lock file
vendor: c=install --prefer-dist --no-dev --no-progress --no-scripts --no-interaction
vendor: composer

## —— Symfony 🎵 ———————————————————————————————————————————————————————————————
sf: ## List all Symfony commands or pass the parameter "c=" to run a given command, example: make sf c=about
	@$(eval c ?=)
	@$(SYMFONY) $(c)

cc: c=c:c ## Clear the cache
cc: sf

## —— PHP 💻 ———————————————————————————————————————————————————————————————
phpunit: ## Fires PHP Unit tests
	@$(eval c=bin/phpunit)
	@$(PHP_CONT) $(c)

cs-fix: ## Runs PHP-CS-Fixer against ./src
	@$(eval c=tools/php-cs-fixer/vendor/bin/php-cs-fixer fix src)
	@$(PHP_CONT) $(c)

## —— Goodies and Extras 💾 —————————————————————————————————————————————————————
scraper: ## Goutte is a screen scraping and web crawling library for PHP.
	@$(eval c=req fabpot/goutte)
	@$(COMPOSER) $(c)

apiplatform: ## API Platform is a powerful yet easy to use full stack framework dedicated to API-driven projects
	@$(eval c=req api)
	@$(COMPOSER) $(c)

booboo: ## A modern error handler capable of logging and formatting errors
	@$(eval c=req league/booboo)
	@$(COMPOSER) $(c)

commonmark: ## Markdown parser for PHP based on the CommonMark spec
	@$(eval c=req league/commonmark)
	@$(COMPOSER) $(c)

event: ## Event package for your app and domain
	@$(eval c=req league/event)
	@$(COMPOSER) $(c)

muffin: ## Enables the rapid creation of objects for testing
	@$(eval c=req league/factory-muffin)
	@$(COMPOSER) $(c)

flysystem: ## Abstraction for local and remote filesystems
	@$(eval c=req league/flysystem:^3.0)
	@$(COMPOSER) $(c)

omnipay: ## Multi-gateway payment processing library
	@$(eval c=require league/omnipay:^3)
	@$(COMPOSER) $(c)

period: ## Period is PHP's Time Range class
	@$(eval c=req league/period)
	@$(COMPOSER) $(c)

calendar: ## Period is PHP's Time Range class
	@$(eval c=require tattali/calendar-bundle)
	@$(COMPOSER) $(c)

csv: ## The library to deal with CSV data using modern code
	@$(eval c=require league/csv)
	@$(COMPOSER) $(c)
