$rg = "aksdemo"
$cluster = "demo-aks-1"
$acr = "demoacr072021"
az login
az account show

# set subscription, phil-VSE-MPN

az group create --name $rg --location westus2

# verify providers are available
az provider show -n Microsoft.OperationsManagement -o table
az provider show -n Microsoft.OperationalInsights -o table

# regsister providers if needed
az provider register --namespace Microsoft.OperationsManagement
az provider register --namespace Microsoft.OperationalInsights

# create the cluster
az aks create --resource-group $rg --name $cluster --node-count 1 --enable-addons monitoring --generate-ssh-keys


# PS C:\demo\devopsug> az aks create --resource-group $rg --name $cluster --node-count 1 --enable-addons monitoring --generate-ssh-keys
# The behavior of this command has been altered by the following extension: aks-preview
# AAD role propagation done[############################################]  100.0000%AzurePortalFqdn                                                  DisableLocalAccounts    DnsPrefix                  EnablePodSecurityPolicy    EnableRbac    Fqdn                                                      KubernetesVersion    Location    MaxAgentPools    Name        NodeResourceGroup              ProvisioningState    ResourceGroup
# ---------------------------------------------------------------  ----------------------  -------------------------  -------------------------  ------------  --------------------------------------------------------  -------------------  ----------  ---------------  ----------  -----------------------------  -------------------  ---------------
# demo-aks-1-aksdemo-5d143f-53d985d0.portal.hcp.westus2.azmk8s.io  False                   demo-aks-1-aksdemo-5d143f  False                      True          demo-aks-1-aksdemo-5d143f-53d985d0.hcp.westus2.azmk8s.io  1.19.11              westus2     100              demo-aks-1  MC_aksdemo_demo-aks-1_westus2  Succeeded            aksdemo

# kubectl stuff

az aks get-credentials --resource-group $rg --name $cluster

### Deployment
kubectl apply -f azure-vote.yaml

kubectl get service azure-vote-front --watch

###
az acr create --resource-group $rg --name $acr --sku Basic

az acr login --name $acr

$acrserver = az acr list --resource-group $rg --query "[].{acrLoginServer:loginServer}" --output json | ConvertFrom-Json
$acrserver

docker tag mcr.microsoft.com/azuredocs/azure-vote-front:v1 "$($acrserver.acrLoginServer)/azure-vote-front:v1"
docker push "$($acrserver.acrLoginServer)/azure-vote-front:v1"

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

az aks show --resource-group $rg --name $cluster --query kubernetesVersion --output table