# kubectl stuff

$rg = "aksdemo"
$cluster = "demo-aks-1"
$acr = "demoacr072021"

# init ACR server address
$acrserver = az acr list --resource-group $rg --query "[].{acrLoginServer:loginServer}" --output json | ConvertFrom-Json
$acrserver

# tag existing mcr container and push it
docker tag mcr.microsoft.com/azuredocs/azure-vote-front:v1 "$($acrserver.acrLoginServer)/azure-vote-front:v1"
docker push "$($acrserver.acrLoginServer)/azure-vote-front:v1"

az aks get-credentials --resource-group $rg --name $cluster

### Deployment
kubectl apply -f azure-vote.yaml

kubectl get service azure-vote-front --watch

#mcr.microsoft.com/azuredocs/azure-vote-front 

az acr repository list --name $acr --output table
az acr repository show-tags --name $acr --repository azure-vote-front --output table

az aks get-credentials --resource-group myResourceGroup --name myAKSCluster

kubkubectl get service azure-vote-front --watch

kubectl get nodes

kubectl get pods

kubectl get pod azure-vote-front-775759d46c-sc6q8 

kubectl describe pod azure-vote-front-775759d46c-sc6q8 

kubectl get service

kubectl scale --replicas=1 deployment/azure-vote-front

# cluster 1.10 or greater have Metrics Server by default
az aks show --resource-group $rg --name $cluster --query kubernetesVersion --output table

kubectl apply -f azure-vote-hpa.yaml

# scale AKS Nodes
az aks scale --resource-group $rg --name $cluster --node-count 3