.DEFAULT_GOAL := help
SHELL := bash
.ONESHELL:

help:
	@grep -E '(^(\w+-?)+:.*?##.*$$)' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'
###########################################################################################################################################################

submodule-init: ## submodule-init
submodule-init:
	git submodule update --init --recursive
	git submodule update --remote --recursive

create-symbolic-links: ## create-symbolic-links
create-symbolic-links:
	rm -Rf modules/doe-tool-bash-k8s-lab/.env
	ln -s ../../.env modules/doe-tool-bash-k8s-lab/
	rm -Rf modules/doe-tool-bash-k8s-lab/kind-config.yaml
	ln -s ../../kind-config.yaml modules/doe-tool-bash-k8s-lab/
	rm -Rf modules/doe-tool-bash-k8s-lab/hosts-demo.conf
	ln -s ../../hosts-demo.conf modules/doe-tool-bash-k8s-lab/

config-etc-hosts: ## config-etc-hosts
config-etc-hosts:
	$(MAKE) -f modules/doe-tool-bash-k8s-lab/Makefile config-etc-hosts

import-certificates: ## import-certificates
import-certificates:
	source modules/doe-tool-bash-k8s-lab/tools
	import_certificates

create-cluster: ## create-cluster
create-cluster: create-docker-network create-kind deploy-metrics-server deploy-metallb deploy-nginx-ingress-controller deploy-cert-manager

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

deploy-cert-manager: ## deploy-cert-manager
deploy-cert-manager:
	$(MAKE) -f modules/doe-tool-bash-k8s-lab/Makefile deploy-cert-manager

destroy-cluster: ## destroy
destroy-cluster:
	$(MAKE) -f modules/doe-tool-bash-k8s-lab/Makefile destroy

#####################################################################################################################################################
docker-build-app1: ## docker-build-app1
docker-build-app1:
	source modules/doe-tool-bash-k8s-lab/tools
	docker_build --env-file=.env --env-file=app1.env --env-file=common.env
push-images-app1: ## push-images-app1
push-images-app1:
	source modules/doe-tool-bash-k8s-lab/tools
	push_images --env-file=.env --env-file=app1.env --env-file=common.env --debug
helm-template-app1: ## helm-template-app1
helm-template-app1:
	source modules/doe-tool-bash-k8s-lab/tools
	helm_template --env-file=.env --env-file=app1.env --env-file=common.env --debug
helm-upgrade-app1: ## helm-upgrade-app1
helm-upgrade-app1:
	source modules/doe-tool-bash-k8s-lab/tools
	helm_upgrade --env-file=.env --env-file=app1.env --env-file=common.env --debug
post-deploy-app1: ## post-deploy-app1
post-deploy-app1:
# eval env files
	for i in .env app1.env common.env; do eval $$(cat $$i); done
# export KUBE_CONTEXT and import-certificates locally
	export KUBE_CONTEXT
	make import-certificates
# switch context
	kubectx $$KUBE_CONTEXT
# switch namespace
	kubens $$HELM_NAMESPACE
# list resources
	kubectl get all --context $$KUBE_CONTEXT --namespace $$HELM_NAMESPACE
# list ingresses
	kubectl get ingress --context $$KUBE_CONTEXT --namespace $$HELM_NAMESPACE
deploy-app1: ## deploy-app1
deploy-app1: config-etc-hosts docker-build-app1 push-images-app1 helm-template-app1 helm-upgrade-app1 post-deploy-app1
helm-uninstall-app1: ## helm-uninstall-app1
helm-uninstall-app1:
	for i in .env app1.env common.env; do eval $$(cat $$i); done
	helm uninstall \
		--kube-context $$KUBE_CONTEXT \
		--namespace $$HELM_NAMESPACE \
		$$HELM_RELEASE
	kubectl delete namespace $$HELM_NAMESPACE --context $$KUBE_CONTEXT
#####################################################################################################################################################
docker-build-app1-dev: ## docker-build-app1-dev
docker-build-app1-dev:
	source modules/doe-tool-bash-k8s-lab/tools
	docker_build --env-file=.env --env-file=app1-dev.env --env-file=common.env
push-images-app1-dev: ## push-images-app1-dev
push-images-app1-dev:
	source modules/doe-tool-bash-k8s-lab/tools
	push_images --env-file=.env --env-file=app1-dev.env --env-file=common.env
helm-template-app1-dev: ## helm-template-app1-dev
helm-template-app1-dev:
	source modules/doe-tool-bash-k8s-lab/tools
	helm_template --env-file=.env --env-file=app1-dev.env --env-file=common.env
helm-upgrade-app1-dev: ## helm-upgrade-app1-dev
helm-upgrade-app1-dev:
	source modules/doe-tool-bash-k8s-lab/tools
	helm_upgrade --env-file=.env --env-file=app1-dev.env --env-file=common.env --debug
post-deploy-app1-dev: ## post-deploy-app1-dev
post-deploy-app1-dev:
# eval env files
	for i in .env app1-dev.env common.env; do eval $$(cat $$i); done
# export KUBE_CONTEXT and import-certificates locally
	export KUBE_CONTEXT
	make import-certificates
# switch context
	kubectx $$KUBE_CONTEXT
# switch namespace
	kubens $$HELM_NAMESPACE
# list resources
	kubectl get all --context $$KUBE_CONTEXT --namespace $$HELM_NAMESPACE
# list ingresses
	kubectl get ingress --context $$KUBE_CONTEXT --namespace $$HELM_NAMESPACE
deploy-app1-dev: ## deploy-app1-dev
deploy-app1-dev: config-etc-hosts docker-build-app1-dev push-images-app1-dev helm-template-app1-dev helm-upgrade-app1-dev post-deploy-app1-dev
helm-uninstall-app1-dev: ## helm-uninstall-app1-dev
helm-uninstall-app1-dev:
	for i in .env app1-dev.env common.env; do eval $$(cat $$i); done
	helm uninstall \
		--kube-context $$KUBE_CONTEXT \
		--namespace $$HELM_NAMESPACE \
		$$HELM_RELEASE
	kubectl delete namespace $$HELM_NAMESPACE --context $$KUBE_CONTEXT