SHELL := /bin/bash

HELM_REPO := prometheus-community
HELM_CHART := kube-prometheus-stack
VALUES_FILE := values.yaml
RELEASE_NAME := monitoring

RESOURCE_GROUP := rg-finserve-staging
VM_NAME := vm-finserve-staging

.PHONY: install-prometheus install-node-exporter port-forward cleanup

install-prometheus:
	@echo "Installing $(HELM_CHART) from $(HELM_REPO)..."
	helm repo add $(HELM_REPO) https://$(HELM_REPO).github.io/helm-charts --force-update
	helm repo update
	helm upgrade --install $(RELEASE_NAME) $(HELM_REPO)/$(HELM_CHART) \
		--namespace monitoring --create-namespace \
		-f $(VALUES_FILE) \
		--wait
	@echo "$(HELM_CHART) installed with VM scraping configured"

install-node-exporter:
	@echo "Installing Node Exporter on VM ($(VM_IP):9100)"
	az vm run-command invoke \
		--resource-group $(RESOURCE_GROUP) \
		--name $(VM_NAME) \
		--command-id RunShellScript \
		--scripts "curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh && systemctl start docker && docker run -d -p 9100:9100 --name=node-exporter prom/node-exporter:latest --web.listen-address=:9100"
	@echo "Node Exporter installed on VM (port 9100)"

port-forward:
	kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090 &
	kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80 &
	wait

cleanup:
	@echo "Removing $(HELM_CHART) stack..."
	helm uninstall $(RELEASE_NAME) -n monitoring
	kubectl delete namespace monitoring --ignore-not-found=true
	@echo "$(HELM_CHART) stack removed"
