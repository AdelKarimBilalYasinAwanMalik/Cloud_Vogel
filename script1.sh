#!/bin/bash
echo "start der installation"
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
echo "zwischenstand 1"
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo groupadd docker
sudo usermod -aG docker $USER
echo "zwischenstand 2"
sudo systemctl enable docker
sudo docker run -d --name prometheus-container -e TZ=CET -p 30090:9090 ubuntu/prometheus:2.33-22.04_beta
sudo docker run -d --name grafana-container -e TZ=CET -p 3000:3000 grafana/grafana-oss
echo "Container laufen jetzt"