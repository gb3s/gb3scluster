cluster_name=gb3s
sudo cp action_runner_agent.yml "$cluster_name"_action_runner_agent.yml
sudo sed -i "s#CLUSTER_NAME#$cluster_name#g" "$cluster_name"_action_runner_agent.yml
kubectl apply "$cluster_name"_action_runner_agent.yml -n actions-runner-system