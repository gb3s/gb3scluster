helm repo add aad-pod-identity https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts
helm repo add jetstack https://charts.jetstack.io
helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller
helm repo add azure-apim-gateway https://azure.github.io/api-management-self-hosted-gateway/helm-charts/

helm repo update

cluster_name=gb3s

helm upgrade aad-pod-identity aad-pod-identity/aad-pod-identity \
  --namespace aad-identity-system --create-namespace \
  --set nmi.allowNetworkPluginKubenet=true \
  --install

helm upgrade \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.8.2 \
  --set installCRDs=true \
  --install

###Actions Runner Image Setup

az acr login -n "$cluster_name"acr

docker build -t "$cluster_name"runner:latest .

docker tag "$cluster_name"\runner:latest ""$cluster_name"acr.azurecr.io/"$cluseter_name"/runner:latest"

docker push "$cluster_name"/runeer:latest

##Actions Runner Setup
gb3s_clientId=$(az identity show -n "$cluster_name-cluster" -g $cluster_name)

kubectl apply -f agentIdentity.yml -n actions-runner-system

helm upgrade --install --namespace actions-runner-system --create-namespace  \
  --wait actions-runner-controller actions-runner-controller/actions-runner-controller \
  --values values.yml
  
kubectl apply -f orgRunner.yml
