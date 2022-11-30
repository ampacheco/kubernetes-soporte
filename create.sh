#!/bin/bash

set -o pipefail
set -e

az group create -n ${AZ_RES_GROUP_NAME:=aks-agic-rg} -l westus
az aks create -n agic-aks -g ${AZ_RES_GROUP_NAME} --network-plugin azure --enable-managed-identity -a ingress-appgw --appgw-name myApplicationGateway --appgw-subnet-cidr "10.225.0.0/16" --generate-ssh-keys
az aks get-credentials -n agic-aks -g ${AZ_RES_GROUP_NAME} --overwrite-existing
echo app-1 app-2 |xargs -n 1 kubectl create ns

echo -n ${image:=mcr.microsoft.com/dotnet/samples:aspnetapp}

kubectl -n app-1 create deployment app-1 --image ${image}
kubectl -n app-2 create deployment app-2 --image ${image}


kubectl -n app-1 expose deployment app-1 --port 80
kubectl -n app-2 expose deployment app-2 --port 80



cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  namespace: app-1
  name: app-1-ingress
  annotations:
    kubernetes.io/ingress.class: azure/application-gateway
spec:
  rules:
  - host: app-1.alejandropacheco.io
    http:
      paths:
      - path: /
        backend:
          service:
            name: app-1
            port:
              number: 80
        pathType: Exact
EOF


cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  namespace: app-2
  name: app-2-ingress
  annotations:
    kubernetes.io/ingress.class: azure/application-gateway
spec:
  rules:
  - host: app-2.alejandropacheco.io
    http:
      paths:
      - path: /
        backend:
          service:
            name: app-2
            port:
              number: 80
        pathType: Exact
