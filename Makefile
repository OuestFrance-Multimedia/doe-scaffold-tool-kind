.DEFAULT_GOAL := help
SHELL := bash
.ONESHELL:

help:
	@grep -E '(^(\w+-?)+:.*?##.*$$)' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'
###########################################################################################################################################################

create-symbolic-links: ## create-symbolic-links
create-symbolic-links:
	rm -Rf modules/doe-tool-bash-k8s-lab/.env
	ln -s ../../.env modules/doe-tool-bash-k8s-lab/
	rm -Rf modules/doe-tool-bash-k8s-lab/kind-config.yaml
	ln -s ../../kind-config.yaml modules/doe-tool-bash-k8s-lab/

create-cluster: ## create-cluster
create-cluster:
	$(MAKE) -f modules/doe-tool-bash-k8s-lab/Makefile create-docker-network
	$(MAKE) -f modules/doe-tool-bash-k8s-lab/Makefile create-kind
# $(MAKE) -f modules/doe-tool-bash-k8s-lab/Makefile deploy-metrics-server
# $(MAKE) -f modules/doe-tool-bash-k8s-lab/Makefile deploy-metallb
# $(MAKE) -f modules/doe-tool-bash-k8s-lab/Makefile deploy-nginx-ingress-controller

create-docker-network: ## create-docker-network
create-docker-network:
	$(MAKE) -f modules/doe-tool-bash-k8s-lab/Makefile create-docker-network

create-kind: ## create-kind
create-kind:
	$(MAKE) -f modules/doe-tool-bash-k8s-lab/Makefile create-kind

deploy-metrics-server: ## deploy-metrics-server
deploy-metrics-server:
	$(MAKE) -f modules/doe-tool-bash-k8s-lab/Makefile deploy-metrics-server

deploy-metallb: ## deploy-metallb
deploy-metallb:
	$(MAKE) -f modules/doe-tool-bash-k8s-lab/Makefile deploy-metallb

deploy-nginx-ingress-controller: ## deploy-nginx-ingress-controller
deploy-nginx-ingress-controller:
	$(MAKE) -f modules/doe-tool-bash-k8s-lab/Makefile deploy-nginx-ingress-controller


destroy-cluster: ## destroy
destroy-cluster:
	$(MAKE) -f modules/doe-tool-bash-k8s-lab/Makefile destroy