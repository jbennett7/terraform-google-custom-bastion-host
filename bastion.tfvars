startup_script = <<EOF
sudo apt-get update -y
sudo apt-get install -y kubectl git
sudo apt-get -y full-upgrade
mkdir ~/bin
git clone https://github.com/ahmetb/kubectx.git ~/.kubectx
cat << FOE >> ~/.bob
export PATH=~/.kubectx:~/bin:~/istio-$${ISTIO_VERSION}/bin:\$PATH
FOE
curl -L "https://github.com/istio/istio/releases/download/$${ISTIO_VERSION}/istio-$${ISTIO_VERSION}-linux.tar.gz" | tar zxf -
cd ~/bin
curl -L "https://get.helm.sh/helm-$${HELM_VERSION}-linux-amd64.tar.gz" | tar zxf - --strip=1 linux-amd64/helm
wget "https://github.com/projectcalico/calicoctl/releases/download/$${CALICO_VERSION}/calicoctl-linux-amd64"
mv calicoctl-linux-amd64 calicoctl
chmod a+x helm calicoctl
echo "gcloud container clusters get-credentials $${CLUSTER_NAME} --region $${CLUSTER_REGION} --project $${PROJECT}" >> /etc/profile
EOF

cluster_name = "secure-gke"
region = "us-west1"
project = "joey-246820"
isito_version = "1.1.7"
helm_version = "v3.0.0-alpha.1"
calico_version = "v3.8.0"
bastion_machine_type = "f1-micro"
bastion_tags = ["bastion", "ssh"]
network = "secure-gke"
