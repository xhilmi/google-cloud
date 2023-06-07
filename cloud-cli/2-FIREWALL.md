# 1.  Create Firewall
- https://cloud.google.com/sdk/gcloud/reference/compute/firewall-rules/create
```
gcloud compute firewall-rules create xkube-allow \
  --allow tcp:80,tcp:443 \
  --description "Allow incoming traffic on TCP port 80 + 443" \
  --direction "INGRESS" \
  --target-tags "xkube-allow" \
  --source-ranges "10.5.0.0/20,10.4.0.0/19,10.0.0.0/16,172.16.0.0/28" \
  --priority 0 \
  --project "PROJECT_ID"
```

# 2. Create VM Instance
- https://cloud.google.com/sdk/gcloud/reference/compute/instances/create
```
gcloud compute machine-types list --filter="name:(e2) zone:(asia-southeast2)"
```
```
gcloud compute images list --filter="name~'ubuntu'"
```
```
gcloud compute instances create xkube-vm \
  --machine-type "e2-micro" \
  --image-project "ubuntu-os-cloud" \
  --image-family "ubuntu-minimal-2204-lts" \
  --zone "us-central1-a" \
  --metadata startup-script="sudo apt update; sudo apt install nginx docker.io -y; sudo systemctl start nginx; sudo systemctl start docker; sudo systemctl enable nginx; sudo systemctl enable docker" \
  --tags "xkube-allow" \
  --project "PROJECT_ID"
```