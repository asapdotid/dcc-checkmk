##@ [Utility Commands]

# @see https://stackoverflow.com/a/43076457
execute-in-container:
	@$(if $(DOCKER_SERVICE_NAME),,$(error DOCKER_SERVICE_NAME is undefined))
	@$(if $(COMMAND),,$(error COMMAND is undefined))
	$(EXECUTE_IN_ANY_CONTAINER) $(COMMAND)

.PHONY: cmk-shell
cmk-shell: ## Execute shell script in Checkmk container with arguments ARGS="odm"
	@$(EXECUTE_IN_ANY_CONTAINER) $(ARGS);
