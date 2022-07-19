SHELL := /bin/bash

run:
	go run main.go

# ==============================================================================
# Building containers

VERSION := 1.0

all: service

service:
	docker build \
		-f zarf/docker/Dockerfile \
		-t service-amd64:$(VERSION) \
		--build-arg BUILD_REF=$(VERSION) \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		.

# ==============================================================================
# Running from within k8s/kind

KIND_CLUSTER := service-starter-cluster

kind-up:
	kind create cluster \
		--image kindest/node:v1.24.0@sha256:0866296e693efe1fed79d5e6c7af8df71fc73ae45e3679af05342239cdc5bc8e \
		--name $(KIND_CLUSTER) \
		--config zarf/k8s/kind/kind-config.yaml
	kubectl config set-context --current --namespace=service-system

kind-down:
	kind delete cluster --name $(KIND_CLUSTER)

kind-load:
	kind load docker-image service-amd64:$(VERSION) --name $(KIND_CLUSTER)

kind-apply:
	kustomize build zarf/k8s/kind/service-pod | kubectl apply -f -

kind-delete:
	kustomize build zarf/k8s/kind/service-pod | kubectl delete -f -

kind-status:
	kubectl get nodes -o wide
	kubectl get svc -o wide
	kubectl get pods -o wide --watch --all-namespaces

kind-service-pod-status:
	kubectl get pods -o wide --watch 

kind-logs:
	kubectl logs -l app=service --all-containers=true -f --tail=100 

kind-describe:
	kubectl describe nodes
	kubectl describe svc
	kubectl describe pod -l app=service 

kind-restart:
	kubectl rollout restart deployment service-pod 

kind-update: all kind-load kind-restart

kind-update-apply: all kind-load kind-apply

tidy:
	go mod tidy

.PHONY: \
	tidy \
	run \
	all \ 
	service \
	kind-up \
	kind-down \
	kind-load \
	kind-apply \
	kind-delete \
	kind-status \
	kind-status \
	kind-logs \
	kind-describe \
	kind-restart \
	kind-update \
	kind-update-apply \
