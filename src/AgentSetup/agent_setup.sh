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

kubectl apply -f agentIdentity.yml -n actions-runner-system

helm upgrade --install --namespace actions-runner-system --create-namespace  \
  --wait actions-runner-controller actions-runner-controller/actions-runner-controller \
  --values values.yml
  
kubectl apply -f orgRunner.yml

helm upgrade azure-api-management-gateway \
             --namespace apim-ingress --create-namespace \
             --set gateway.configuration.uri='gb3s-apim.configuration.azure-api.net' \
             --set gateway.auth.key='GatewayKey gb3s-internal-gateway&202208082120&Ie+FkkpNLYET4AAE1dKa4yCLqoZTi0Qk/Auddr+jwr5naSyeQ2Bqf+I9k3qiQSg80Gc5P9sUNnLhOlgkk4xhlg==' \
             --values apimValues.yml \
             --install azure-apim-gateway/azure-api-management-gateway

kubectl apply -f apimRBAC.yml -n apim-ingress