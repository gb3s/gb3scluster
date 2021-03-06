curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

sudo apt-get install docker.io

sudo apt get install linuxbrew-wrapper
brew install k9s

bash get_helm.sh