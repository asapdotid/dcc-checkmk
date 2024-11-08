##@ [Utility: Commands]

.PHONY: omd
omd: ## Running omd script in container with ARGS="status"
    # @$(DOCKER_SERVICE_CHECKMK_NAME) omd su cmk
	@$(EXECUTE_IN_BROCKER_CONTAINER) omd $(ARGS)

.PHONY: passwd
passwd: ## Running cmk-passwd script in container with USER="cmkadmin"
	@$(EXECUTE_IN_BROCKER_CONTAINER) omd su cmk
	@$(EXECUTE_IN_BROCKER_CONTAINER) cmk-passwd $(USER)

.PHONY: shell
shell: ## Running shell script in container with ARGS="ls -al"
	@$(EXECUTE_IN_BROCKER_CONTAINER) $(ARGS)
