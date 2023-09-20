terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

# provider "kubectl" {
#   config_path = "~/.kube/config"  # my default location
# }

provider "kubectl" {
  config_path = "./kubeconfig"  # the kubeconfig file which was created in the folder
}

resource "kubectl_manifest" "gerald_deployment" {
  yaml_body = <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: njoku-gerald-deployment
  labels:
    app: njoku-gerald
spec:
  replicas: 1
  selector:
    matchLabels:
      app: njoku-gerald
  template:
    metadata:
      labels:
        app: njoku-gerald
    spec:
      containers:
      - name: njoku-gerald
        image: bopgeek/my-express-app:latest 
        ports:
        - containerPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: njoku-gerald-service
spec:
  selector:
    app: njoku-gerald
  ports:
    - protocol: TCP
      port: 3000
      targetPort: 3000
  type: LoadBalancer  
EOF
}

resource "kubectl_manifest" "gerald_service" {
  yaml_body = <<EOF
apiVersion: v1
kind: Service
metadata:
  name: njoku-gerald-service
spec:
  selector:
    app: njoku-gerald
  ports:
    - protocol: TCP
      port: 3000
      targetPort: 3000
  type: LoadBalancer  
EOF
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  # Path to your kubeconfig file
  }
}

resource "helm_release" "kube_prometheus_stack-ifeanyi" {
  name       = "kube-prometheus-stack-ifeanyi"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "19.0.3"  # Replace with the desired version
  namespace  = "monitoring" 

  values = [
    <<-YAML
    grafana:
      enabled: true
      adminPassword: prom-operator
      service:
        type: LoadBalancer  # Change this to the service type you prefer
      ingress:
        enabled: true
        annotations:
          nginx.ingress.kubernetes.io/rewrite-target: /
        hosts:
          - grafana.example.com  # Replace with your desired hostname

    prometheus:
      alertmanager:
        alertmanagerSpec:
          storage:
            volumeClaimTemplate:
              spec:
                storageClassName: default  # Change this to your storage class if needed
                accessModes:
                  - ReadWriteOnce
                resources:
                  requests:
                    storage: 5Gi  # Adjust the storage size as per your requirements

    # Disable the creation of PSPs
    podSecurityPolicy:
      enabled: false  # Disable PSPs

    # Additional configurations for the kube-prometheus-stack can be added here.
    YAML
  ]
}
# namespaceOverride: "monitoring"  # Set the target namespace
