1. Create VPC Network
    # https://cloud.google.com/sdk/gcloud/reference#--project
    gcloud compute networks create xkube-net \
      --subnet-mode "custom" \
      --project "PROJECT_ID"

2. Create VPC Subnetwork
    - Create secondary network for pods
    - Create secondary network for services
    - Create subnet tag
    # https://cloud.google.com/sdk/gcloud/reference/compute/networks/subnets
    gcloud compute networks subnets create xkube-subnet \
      --network "xkube-net" \
      --region "us-central1" \
      --range 10.5.0.0/20 \
      --secondary-range xkube-pods=10.4.0.0/19 \
      --secondary-range xkube-services=10.0.0.0/16 \
      --enable-private-ip-google-access \
      --project "PROJECT_ID"