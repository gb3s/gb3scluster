sudo az acr login -n gb3sacr
sudo docker build -t "$cluster_name"/runner:latest .
sudo docker tag "$cluster_name"/runner:latest ""$cluster_name"acr.azurecr.io/"$cluseter_name"/runner:latest"
sudo docker push "$cluster_name"/runner:latest