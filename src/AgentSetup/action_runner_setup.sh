cluster_name=gb3s
##Actions Runner Setup

id="$(az identity show -n "$cluster_name-cluster" -g $cluster_name --query id)"
clientId="$(az identity show -n "$cluster_name-cluster" -g $cluster_name --query clientId)"

sudo cp agentIdentity.yml "$cluster_name"Identity.yml

echo $cluster_name
echo $id
echo $clientId

sudo sed -i "s#CLUSTER_NAME#$cluster_name#g" "$cluster_name"Identity.yml
sudo sed -i "s#CLIENTID#$clientId#g"         "$cluster_name"Identity.yml
sudo sed -i "s#RESOURCEID#$id#g"              "$cluster_name"Identity.yml