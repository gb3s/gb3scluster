helm repo add aad-pod-identity https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts
helm repo add jetstack https://charts.jetstack.io
helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller
helm repo add azure-apim-gateway https://azure.github.io/api-management-self-hosted-gateway/helm-charts/

helm repo update

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

kubectl create ns actions-runner-system
kubectl apply -f agentIdentity.yml -n actions-runner-system

helm upgrade --install --namespace actions-runner-system  \
  --wait actions-runner-controller actions-runner-controller/actions-runner-controller \
  --values values.yml
  
kubectl apply -f orgRunner.yml

helm install azure-api-management-gateway \
             --set gateway.configuration.uri='gb3s-apim.configuration.azure-api.nethttps://gb3s-apim.management.azure-api.net/subscriptions/4dc1bd33-fef6-413d-aa31-bc639452a449/resourceGroups/gb3s/providers/Microsoft.ApiManagement/service/gb3s-apim?api-version=2021-01-01-preview' \
             --set gateway.auth.key='N0vb6CKyPXtDTfSf6AL5hTVL/RKfPx1FIvHAkDgsdlqbYuEMRhGtsc/25ELnywlDHJV5Tqh/aarmDJF4eAo8dg==' \
             azure-apim-gateway/azure-api-management-gateway