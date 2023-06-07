# Create Firewall
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