$rg = "aksdemo"
$cluster = "demo-aks-1"
$acr = "demoacr072021"

az login
az account show

az account set -s phil-VSE-MPN

az group create --name $rg --location westus2

# verify providers are available
az provider show -n Microsoft.OperationsManagement -o table
az provider show -n Microsoft.OperationalInsights -o table

# regsister providers if needed
az provider register --namespace Microsoft.OperationsManagement
az provider register --namespace Microsoft.OperationalInsights

# create the cluster
az aks create --resource-group $rg --name $cluster --node-count 1 --enable-addons monitoring --generate-ssh-keys

###
az acr create --resource-group $rg --name $acr --sku Basic

az acr login --name $acr

# Enable acr admin mode
az acr update -g $rg -n $acr --admin-enabled true

# show the credentials, useful for pipelines and such
az acr credential show -n $acr -g $rg
