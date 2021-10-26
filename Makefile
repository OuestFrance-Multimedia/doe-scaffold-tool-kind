.DEFAULT_GOAL := help
SHELL := bash
.ONESHELL:

help:
	@grep -E '(^(\w+-?)+:.*?##.*$$)' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'
###########################################################################################################################################################
install: ## install
install:
	$(MAKE) -f modules/doe-tool-bash-k8s-lab/Makefile install

init: ## init
init: submodule-init submodule-update make-symbolic-links

submodule-init: ## submodule-init
submodule-init:
	git submodule update --init --recursive

# for m in modules/*; do git submodule update $$m; done
submodule-update: ## submodule-update
submodule-update:
	source modules/doe-tool-bash-k8s-lab/tools
	submodule_update

create-symbolic-links: ## create-symbolic-links
create-symbolic-links:
	rm -Rf modules/doe-tool-bash-k8s-lab/.env
	ln -s ../../.env modules/doe-tool-bash-k8s-lab/
	rm -Rf modules/doe-tool-bash-k8s-lab/kind-config.yaml
	ln -s ../../kind-config.yaml modules/doe-tool-bash-k8s-lab/

create-cluster: ## create
create-cluster:
	$(MAKE) -f modules/doe-tool-bash-k8s-lab/Makefile create

destroy-cluster: ## destroy
destroy-cluster:
	$(MAKE) -f modules/doe-tool-bash-k8s-lab/Makefile destroy