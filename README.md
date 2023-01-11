# kubernetes-soporte

## Soporte 
````
echo "Resources: \n" && k api-resources && echo "\nVersions: \n" && k api-versions # Listar todos los Recursos en el Cluster y las versiones            
k get [ingress-resource] [ingress-name] -oyaml   # Obtener la Configuración del ingress --mapeo de url a servicio--       
````

## Deploy aks with AGIC --Addon Way
````
az group create -n ${resourceGroup:=aks-agic-rg} -l eastus
az aks create -n myCluster -g "${resourceGroup}" --network-plugin azure --enable-managed-identity -a ingress-appgw --appgw-name myApplicationGateway --appgw-subnet-cidr "10.225.0.0/16" --generate-ssh-keys
 az aks get-credentials -n myCluster -g "${resourceGroup}"
 ````

## Deploy aks with AGIC --AGIC with helm
````
# 
````


## Configurar el Certificado tls para el Ingress Referencia

[Step By Step](https://adolfi.dev/blog/tls-kubernetes/)
