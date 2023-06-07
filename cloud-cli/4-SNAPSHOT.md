# Create Snapshot
- https://cloud.google.com/sdk/gcloud/reference/compute/disks/snapshot
```
gcloud compute disks snapshot xkube-vm \
  --zone "us-central1-a" \
  --snapshot-names "xkube-snapshot" \
  --project "PROJECT_ID"
```