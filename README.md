# DevOps Intern Task by Ignite

-----------
Description
------------

> I used Minikube instead of kind because I already had it installed on my local machine, hopefully it doesn't disqualify me

------------
- I Wrote a simple bash script that deploys or starts a minikube cluster locally.
-  Download the kubeconfig for the cluster and store in a safe place, we will use it much later in the next steps.
- When minikube is up and running, I dockerized a simple `hello world express app` and deploy to dockerhub.
- I created a kubernetes deployment manifest to deploy  the Node.js dockerized app to the Minikube cluster but 
- using the kubectl terraform provider, I wrote a terraform code to deploy the kubectl manifest to the minikube cluster.

- Using the kube-prometheus stack, using terraform helm provider, setup monitoring and observability for the prometheus cluster.

-----
### For the Prometheus Installation
to start minikube
```bash
minikube start --driver=docker
or
minikube start
```

for windows installation
```bash
choco install kubernetes-helm
```
for linux installation
```bash
sudo apt-get install helm
```

for MacOs installation
```bash
brew install helm
```

```bash
helm
```
install helm repo
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus
```
```bash
kubectl get all
kubectl get service
```
expose the service port
```bash
kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext
service/prometheus-server-ext exposed
```

```bash
minikube service prometheus-server-ext
```

---------
### For the Kube Prometheus Installation

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```
create a namespace
```bash
kubectl create namespace monitoring
```

installtion
```bash
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace monitoring
```

getting the password
```bash
kubectl get secret --namespace monitoring kube-prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
start the service
```bash
kubectl port-forward --namespace monitoring svc/kube-prometheus-stack-grafana 3000:80
```