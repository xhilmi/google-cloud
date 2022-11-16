# Simple HTTP Load Balancer in Google Cloud Platform
# Debian or Ubuntu

# Compute Engine
- Instance Groups
- Create Instance Group
- New managed instance group (stateless)
  - Name : lb-group-example
  - Description : load balancer instance group
  - Instance template
    - Create a new Instance template
      - Machine configuration >>> N1 f1-micro
      - Boot disk >>> Debian or Ubuntu >>> 10GB
      - Identity and API access >>> Allow default access
      - Networking >>> Network tags
      - Management >>> Automation
        - Startup script
          #!/bin/bash
          sudo apt-get update
          sudo apt-get install apache2 -y
          sudo a2ensite default-ssl
          sudo a2enmod ssl
          vm_hostname="$(curl -s -H "Metadata-Flavor:Google" http://metadata/computeMetadata/v1/instance/name)"
          sudo echo "Page load balancer served from: $vm_hostname" | \
          sudo tee /var/www/html/index.html
          sudo systemctl restart apache2

  - d
  - d
  - d
- Location : Single zone (choose cheapest)
- Autoscaling : On add and remove instance to the group
  - nginx-php.yml
    - oke
- Autoscaling metrics : CPU utilization 60%



