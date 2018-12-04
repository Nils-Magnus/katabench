#!/bin/sh

echo "Configure Docker repo ..."
sudo -E apt-get -y install apt-transport-https ca-certificates wget software-properties-common
curl -sL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
arch=$(dpkg --print-architecture)
sudo -E add-apt-repository "deb [arch=${arch}] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo -E apt-get update

echo "Install Docker ..."
sudo -E apt-get -y install docker-ce

echo "Enable user 'ubuntu' to use Docker ..."
sudo usermod -aG docker ubuntu

echo "Configure Kata repo ..."
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/katacontainers:/release/xUbuntu_$(lsb_release -rs)/ /' > /etc/apt/sources.list.d/kata-containers.list"
curl -sL  http://download.opensuse.org/repositories/home:/katacontainers:/release/xUbuntu_$(lsb_release -rs)/Release.key | sudo apt-key add -
sudo -E apt-get update

echo "Install Kata components ..."
sudo -E apt-get -y install kata-runtime kata-proxy kata-shim

echo "Create new Systemd unit ..."
sudo mkdir -p /etc/systemd/system/docker.service.d/
cat <<EOF | sudo tee /etc/systemd/system/docker.service.d/kata-containers.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -D --add-runtime kata-runtime=/usr/bin/kata-runtime --default-runtime=kata-runtime
EOF

echo "Restart Docker with new OCI driver ..."
sudo systemctl daemon-reload
sudo systemctl restart docker

echo "Run first container in new runtime ..."
docker run -it ubuntu
