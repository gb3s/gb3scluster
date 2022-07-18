cluster_name=gb3s
##Actions Runner Setup

id="$(az identity show -n "$cluster_name-cluster" -g $cluster_name --query id)"
clientId="$(az identity show -n "$cluster_name-cluster" -g $cluster_name --query clientId)"

sudo cp action_runner_identity.yml "$cluster_name"_action_runner_identity.yml

echo $cluster_name
echo $id
echo $clientId

sudo sed -i "s#CLUSTER_NAME#$cluster_name#g" "$cluster_name"_action_runner_identity.yml
sudo sed -i "s#CLIENTID#$clientId#g"         "$cluster_name"_action_runner_identity.yml
sudo sed -i "s#RESOURCEID#$id#g"             "$cluster_name"_action_runner_identity.yml

kubectl apply -f "$cluster_name"_action_runner_identity.yml -n actions-runner-system

sudo rm "$cluster_name"_action_runner_identity.yml