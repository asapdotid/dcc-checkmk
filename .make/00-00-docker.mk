# Container names
## must match the names used in the docker-composer.yml files
DOCKER_SERVICE_NAME:=checkmk

# Naming convention for images is $(DOCKER_REGISTRY)/$(DOCKER_NAMESPACE)/$(DOCKER_IMAGE):$(DOCKER_IMAGE_TAG)
# e.g.                      docker.io/checkmk/check-mk-raw:2.3.0-latest
# $(DOCKER_REGISTRY)     -----^           ^         ^      ^    docker.io
# $(DOCKER_NAMESPACE)    -----------------^         ^      ^    checkmk
# $(DOCKER_IMAGE)        ---------------------------^      ^    check-mk-raw
# $(DOCKER_IMAGE_TAG)    ----------------------------------^    2.3.0-latest

DOCKER_DIR:=$(CURDIR)/src
DOCKER_ENV_FILE:=$(DOCKER_DIR)/.env
DOCKER_COMPOSE_FILE:=$(DOCKER_DIR)/compose.yml

# we need a couple of environment variables for docker-compose so we define a make-variable that we can
# then reference later in the Makefile without having to repeat all the environment variables
DOCKER_COMPOSE_COMMAND:= \
 DOCKER_REGISTRY=$(DOCKER_REGISTRY) \
 DOCKER_NAMESPACE=$(DOCKER_NAMESPACE) \
 DOCKER_IMAGE=$(DOCKER_IMAGE) \
 DOCKER_IMAGE_TAG=$(DOCKER_IMAGE_TAG) \
 docker compose -p $(DOCKER_PROJECT_NAME) --env-file $(DOCKER_ENV_FILE)

DOCKER_COMPOSE?=
EXECUTE_IN_ANY_CONTAINER?=
EXECUTE_IN_BROCKER_CONTAINER?=

DOCKER_COMPOSE:=$(DOCKER_COMPOSE_COMMAND) -f $(DOCKER_COMPOSE_FILE)

# we can pass EXECUTE_IN_CONTAINER=true to a make invocation in order to execute the target in a docker container.
# Caution: this only works if the command in the target is prefixed with a $(EXECUTE_IN_*_CONTAINER) variable.
# If EXECUTE_IN_CONTAINER is NOT defined, we will check if make is ALREADY executed in a docker container.
# We still need a way to FORCE the execution in a container, e.g. for Gitlab CI, because the Gitlab
# Runner is executed as a docker container BUT we want to execute commands in OUR OWN docker containers!
EXECUTE_IN_CONTAINER?=
ifndef EXECUTE_IN_CONTAINER
	# check if 'make' is executed in a docker container, see https://stackoverflow.com/a/25518538/413531
	# `wildcard $file` checks if $file exists, see https://www.gnu.org/software/make/manual/html_node/Wildcard-Function.html
	# i.e. if the result is "empty" then $file does NOT exist => we are NOT in a container
	ifeq ("$(wildcard /.dockerenv)","")
		EXECUTE_IN_CONTAINER=true
	endif
endif
ifeq ($(EXECUTE_IN_CONTAINER),true)
	EXECUTE_IN_BROCKER_CONTAINER:=$(DOCKER_COMPOSE) exec -T $(DOCKER_SERVICE_NAME)
endif

##@ [Docker: Compose commands]

.PHONY: env
env: compose/.env ## Docker compose initial environment
env:
	@echo "Please update your docker/.env file with your settings"

validate-compose-variables:
	@$(if $(DOCKER_REGISTRY),,$(error DOCKER_REGISTRY is undefined))
	@$(if $(DOCKER_NAMESPACE),,$(error DOCKER_NAMESPACE is undefined))
	@$(if $(DOCKER_IMAGE),,$(error DOCKER_IMAGE is undefined - Did you run make-init?))
	@$(if $(DOCKER_IMAGE_TAG),,$(error DOCKER_IMAGE_TAG is undefined - Did you run make-init?))
	@$(if $(DOCKER_PROJECT_NAME),,$(error DOCKER_PROJECT_NAME is undefined - Did you run make-init?))

compose/.env:
	@cp $(DOCKER_ENV_FILE).example $(DOCKER_ENV_FILE)

.PHONY: up
up: validate-compose-variables ## Create and start all docker containers. To create/start only a specific container, use DOCKER_SERVICE_NAME=<service>
	@$(DOCKER_COMPOSE) up -d $(DOCKER_SERVICE_NAME)

.PHONY: restart
restart: validate-compose-variables ## Restart docker containers.
	@$(DOCKER_COMPOSE) restart $(DOCKER_SERVICE_NAME)

.PHONY: down
down: validate-compose-variables ## Stop and remove all docker containers.
	@$(DOCKER_COMPOSE) down --remove-orphans -v

.PHONY: config
config: validate-compose-variables ## List the configuration docker compose
	@$(DOCKER_COMPOSE) config $(DOCKER_SERVICE_NAME)

.PHONY: logs
logs: validate-compose-variables ## Logs docker containers.
	@$(DOCKER_COMPOSE) logs --tail=100 -f $(DOCKER_SERVICE_NAME)

.PHONY: ps
ps: validate-compose-variables ## Docker composer PS containers.
	@$(DOCKER_COMPOSE) ps $(DOCKER_SERVICE_NAME)
