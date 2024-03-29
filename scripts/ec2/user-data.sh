#!/bin/bash
apt update -y
apt install -y \
    unzip
apt-get update -y
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common

### DOCKER 
echo "Adding Docker apt repository..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |\
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" |\
    tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io 

### TERRAFORM
wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_${OS}_${SYS_ARCH}.zip 
unzip terraform_${TF_VERSION}_${OS}_${SYS_ARCH}.zip 
mv ./terraform /usr/local/bin/

### AWS CLI
echo "Manually installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

### ECR LOGIN
echo "Logging into AWS ECR..."
aws ecr get-login-password \
    --region ${AWS_DEFAULT_REGION} |\
    docker login \
        --username AWS \
        --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com