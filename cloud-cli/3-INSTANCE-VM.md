# 1. Create VM Instance
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

# 2. Create VM Instance from Template
- https://cloud.google.com/sdk/gcloud/reference/compute/instances/create
```
gcloud compute instances create xkube-vm \
  --source-instance-template "xkube-template" \
  --machine-type "e2-micro" \
  --image-project "ubuntu-os-cloud" \
  --image-family "ubuntu-minimal-2204-lts" \
  --zone "us-central1-a" \
  --project "xhilmi"
```