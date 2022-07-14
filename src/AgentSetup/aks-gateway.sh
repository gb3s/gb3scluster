helm install ./helm/ingress-azure \
     --name ingress-azure \
     --namespace apim-ingress \
     --debug \
    #  --set appgw.name=applicationgatewayABCD \
    #  --set appgw.resourceGroup=your-resource-group \
    #  --set appgw.subscriptionId=subscription-uuid \
    #  --set appgw.shared=false \
    #  --set armAuth.type=servicePrincipal \
    #  --set armAuth.secretJSON=$(az ad sp create-for-rbac --role Contributor --sdk-auth | base64 -w0) \
     --set rbac.enabled=true \
     --set verbosityLevel=3 \
     --set kubernetes.watchNamespace=default \
     --set aksClusterConfiguration.apiServerAddress=gb3s-cluster.privatelink.eastus.azmk8s.io