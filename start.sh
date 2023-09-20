#!/bin/bash

# Check if Minikube is installed
if ! command -v minikube &> /dev/null; then
    echo "Minikube is not installed. Please install it first."
    exit 1
fi

# Define the name of your Minikube cluster
CLUSTER_NAME="minikube"

# Check if the cluster already exists
if minikube status --format "{{.KubeletReady}}" | grep -q "True"; then
    echo "Minikube cluster '$CLUSTER_NAME' already exists and is running. Skipping deployment."
else
    # Create a Minikube cluster
    minikube start --profile "$CLUSTER_NAME"
    if [ $? -eq 0 ]; then
        echo "Minikube cluster '$CLUSTER_NAME' created and started successfully."
    else
        echo "Failed to create and start Minikube cluster."
        exit 1
    fi
fi

# Set kubectl context to the Minikube cluster
kubectl config use-context "$CLUSTER_NAME"
