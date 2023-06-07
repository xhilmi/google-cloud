# Create Instance Template
- https://cloud.google.com/sdk/gcloud/reference/compute/instance-templates/create
```
gcloud compute instance-templates create xkube-template \
  --region "us-central1" \
  --image "xkube-image" \
  --boot-disk-type "pd-standard" \
  --boot-disk-size 20 \
  --machine-type "e2-small" \
  --network "xkube-network" \
  --subnet "xkube-subnet" \
  --tags "xkube-allow" \
  --project "PROJECT_ID"
```