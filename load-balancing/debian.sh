# Google Cloud Platform
# Simple HTTP Load Balancer 
# Operating System Debian

# Create Instance Template
### Compute Engine
- Virtual Machine
  - Instance Template
    - Create a new Instance template
    - Name : lb-template-debian
    - Machine configuration : E2 e2-micro
    - Boot disk : Debian or Ubuntu >>> 10GB
    - Identity and API access : Allow default access
    - Networking : Network tags
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

# Create Instance Group
### Compute Engine
- Instance Groups
  - Instance Groups
    - Create Instance Group
      - New managed instance group (stateless)
        - Name : lb-group-debian
        - Description : lb-group-debian
        - Instante template : lb-template-debian
      - Location
        - Multiple zone
          - Region : us-central1 (lowa)
          - Zone : us-central1-all
      - Autoscaling
        - Autoscaling mode : On add and remove instance to the group
        - Minimum number of instances : 2
        - Maximum number of instances : 4
      - Autoscaling metrics
        - CPU utilization : 60% (default)
        - Port mapping : http 80
  - Create     

# Create Health Checks
### Compute Engine
- Instance Groups
  - Health Checks
    - Create Health Check
      - Name : lb-health-check
      - Description : lb-health-check
      - Scope : global
      - Protocol : HTTP
      - Port : 80
      - Proxy protocol : none
      - Request path : /
      - Health criteria : use default settings 
  - Create  
  
# Network Services
- Load Balancing
  - Create Load Balancer
    - HTTP(S) Load Balancing >>> Start Configuration
      - Internet facing or internal only : From Internet to my VMs or serverless services
      - Global or Regional : Global HTTP(S) Load Balancer (classic)
        - Name : lb-website
        - Frontend configuration 
          - Name : lb-frontend
          - Protocol : HTTP
          - Network Service Tier : Premium
          - IP version : IPv4
          - IP address : Ephemeral
          - Port : 80
          - Done
        - Backend configuration
          - Create a backend service
            - Name : lb-backend
            - Description : lb-backend
            - Backend type : instance-group
            - Protocol : HTTP
            - Named port : http
            - Timeout : 30
            - Instance group : lb-group
            - Port numbers : 80
            - Balancing mode : Utilization
            - Maximum backend utilization : 80
            - Maximum RPS : leave blank
            - Scope : per instance
            - Capacity : 100
            - Done
          - Health check : lb-health-check
          - Create
          - OK
        - Host and path rules
          - Simple host and path rule
          - Backend 1 : lb-backend
        - Review and finalize   
  - Create        

