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

cat <<'EOF'>/home/Saiyajin/prometheus.yml
global:
  scrape_interval:     5s
  evaluation_interval: 5s
rule_files:
  # - "first.rules"
  # - "second.rules"
scrape_configs:
  - job_name: NE01
    static_configs:
      - targets: ['192.168.66.184:9100']
  - job_name: NE02
    static_configs:
      - targets: ['192.168.66.185:9100']
  - job_name: NE03
    static_configs:
      - targets: ['192.168.66.183:9100']
EOF

sudo docker run -d -p 9090:9090 -v /home/Saiyajin/prometheus.yml:/etc/prometheus/prometheus.yml --name=prometheus prom/prometheus

sudo docker run -d --name grafana-container -e TZ=CET -p 3000:3000 grafana/grafana-oss
echo "Container laufen jetzt"