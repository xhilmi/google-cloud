# Create Image
- https://cloud.google.com/sdk/gcloud/reference/compute/images/create
```
gcloud compute images create xkube-image \
  --source-snapshot "xkube-snapshot" \
  --project "PROJECT_ID"
```