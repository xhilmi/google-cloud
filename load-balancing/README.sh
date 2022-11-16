# Simple HTTP Load Balancer in Google Cloud Platform
# Debian

# Compute Engine
- Virtual Machine
  - Instance template
    - Create a new Instance template
    - Name : lb-template
    - Machine configuration >>> E2 e2-micro
    - Boot disk >>> Debian or Ubuntu >>> 10GB
    - Identity and API access >>> Allow default access
    - Networking >>> Network tags
    - Advanced options >>> Management >>> Automation
      - Startup script
        #!/bin/bash
        sudo apt-get update
        sudo apt-get install apache2 -y
        sudo a2ensite default-ssl
        sudo a2enmod ssl
        vm_hostname="$(curl -s -H "Metadata-Flavor:Google" http://metadata/computeMetadata/v1/instance/name)"
        sudo echo "Page load balancer served from: $vm_hostname" |
        sudo tee /var/www/html/index.html
        sudo systemctl restart apache2
  - Create
  
# Compute Engine
- Instance Groups
  - Instance Groups
    - Create Instance Group
      - New managed instance group (stateless)
        - Name : lb-group
        - Description : lb-group
        - Instante template : lb-template
      - Location
        - Single zone
          - Region : us-central1 (lowa)
          - Zone : us-central1-a
      - Autoscaling
        - Autoscaling mode : On add and remove instance to the group
        - Minimum number of instances : 5
        - Maximum number of instances : 10
      - Autoscaling metrics
        - CPU utilization : 60% (default)
        - Port mapping : http 80
  - Create     


    

# Network


