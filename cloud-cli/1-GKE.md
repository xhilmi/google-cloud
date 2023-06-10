# 1. Create VPC Network
- https://cloud.google.com/sdk/gcloud/reference#--project
```
gcloud compute networks create xkube-network \
  --subnet-mode "custom" \
  --project "PROJECT_ID"
```
# 2. Create Kubernetes Cluster
- https://cloud.google.com/sdk/gcloud/reference/container/clusters/create
- https://cloud.google.com/sdk/gcloud/reference/container/node-pools/create
```
gcloud container clusters create xkube-cluster \
  --region "us-west2" \
  --network "xkube-network" \
  --cluster-version "1.24.11-gke.1000" \
  --machine-type "e2-medium" \
  --image-type "COS_CONTAINERD" \
  --disk-type "pd-balanced" \
  --disk-size 25 \
  --enable-master-global-access \
  --enable-ip-alias \
  --enable-private-nodes \
  --max-pods-per-node 8 \
  --num-nodes 1 \
  --min-nodes 1 \
  --max-nodes 3 \
  --create-subnetwork name=xkube-subnet,range=10.5.0.0/20 \
  --cluster-secondary-range-name "xkube-pods" \
  --services-secondary-range-name "xkube-services" \
  --cluster-ipv4-cidr 10.4.0.0/19 \
  --services-ipv4-cidr 10.0.0.0/14 \
  --master-ipv4-cidr 172.16.0.0/28 \
  --spot \
  --location-policy "ANY" \
  --project "PROJECT_ID"
```

# 3. Create Routers    
- https://cloud.google.com/sdk/gcloud/reference/compute/routers/create
```
gcloud compute routers create xkube-router \
  --network "xkube-network" \
  --region "us-west2" \
  --project "PROJECT_ID"
```

# 4. Create Nats
- https://cloud.google.com/sdk/gcloud/reference/compute/routers/nats/create
```
gcloud compute routers nats create xkube-nat \
  --router-region "us-west2" \
  --router "xkube-router" \
  --nat-all-subnet-ip-ranges \
  --auto-allocate-nat-external-ips \
  --project "PROJECT_ID"
```

# Note: 
- Don't forget to add your ip on (GKE > Cluster > Edit > Control plane authorized networks > Add IP > Save)

# Others
- Run this to create more customizable nodes
```
gcloud container node-pools create xkube-nodepool \
  --cluster "xkube-cluster" \
  --num-nodes 1 \
  --image-type "COS_CONTAINERD" \
  --machine-type "e2-medium" \
  --disk-size 25 \
  --disk-type "pd-balanced" \
  --max-pods-per-node 8 \
  --project "PROJECT_ID"
```
```
gcloud container clusters get-credentials xkube-cluster \
  --region "us-west2" \
  --project "PROJECT_ID"
```
```
gcloud container clusters update xkube-cluster \
  --max-pods-per-node 8 \
  --project "PROJECT_ID"
```
