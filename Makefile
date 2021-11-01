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
create-cluster: create-docker-network create-kind deploy-metrics-server deploy-metallb deploy-nginx-ingress-controller

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

#####################################################################################################################################################
docker-build-demo: ## docker-build-demo
docker-build-demo:
	source modules/doe-tool-bash-k8s-lab/tools
	docker_build --env-file=.env --env-file=demo.env --env-file=common.env
push-images-demo: ## push-images-demo
push-images-demo:
	source modules/doe-tool-bash-k8s-lab/tools
	push_images --env-file=.env --env-file=demo.env --env-file=common.env
helm-template-demo: ## helm-template-demo
helm-template-demo:
	source modules/doe-tool-bash-k8s-lab/tools
	helm_template --env-file=.env --env-file=demo.env --env-file=common.env
helm-upgrade-demo: ## helm-upgrade-demo
helm-upgrade-demo:
	source modules/doe-tool-bash-k8s-lab/tools
	helm_upgrade --env-file=.env --env-file=demo.env --env-file=common.env
deploy-demo: ## deploy-demo
deploy-demo: docker-build-demo push-images-demo helm-template-demo helm-upgrade-demo
helm-uninstall-demo: ## helm-uninstall-demo
helm-uninstall-demo:
	for i in .env demo.env common.env; do eval $$(cat $$i); done
	helm uninstall \
		--kube-context $$KUBE_CONTEXT \
		--namespace $$HELM_NAMESPACE \
		$$HELM_RELEASE
	kubectl delete namespace $$HELM_NAMESPACE --context $$KUBE_CONTEXT
#####################################################################################################################################################
docker-build-demo-dev: ## docker-build-demo-dev
docker-build-demo-dev:
	source modules/doe-tool-bash-k8s-lab/tools
	docker_build --env-file=.env --env-file=demo-dev.env --env-file=common.env
push-images-demo-dev: ## push-images-demo-dev
push-images-demo-dev:
	source modules/doe-tool-bash-k8s-lab/tools
	push_images --env-file=.env --env-file=demo-dev.env --env-file=common.env
helm-template-demo-dev: ## helm-template-demo-dev
helm-template-demo-dev:
	source modules/doe-tool-bash-k8s-lab/tools
	helm_template --env-file=.env --env-file=demo-dev.env --env-file=common.env
helm-upgrade-demo-dev: ## helm-upgrade-demo-dev
helm-upgrade-demo-dev:
	source modules/doe-tool-bash-k8s-lab/tools
	helm_upgrade --env-file=.env --env-file=demo-dev.env --env-file=common.env
deploy-demo-dev: ## deploy-demo-dev
deploy-demo-dev: docker-build-demo-dev push-images-demo-dev helm-template-demo-dev helm-upgrade-demo-dev
helm-uninstall-demo-dev: ## helm-uninstall-demo-dev
helm-uninstall-demo-dev:
	for i in .env demo-dev.env common.env; do eval $$(cat $$i); done
	helm uninstall \
		--kube-context $$KUBE_CONTEXT \
		--namespace $$HELM_NAMESPACE \
		$$HELM_RELEASE
	kubectl delete namespace $$HELM_NAMESPACE --context $$KUBE_CONTEXT