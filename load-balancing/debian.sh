# Simple HTTP Load Balancer in Google Cloud Platform
# Debian

# Compute Engine
- Virtual Machine
  - Instance Template
    - Create a new Instance template
    - Name : lb-template
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
    
# Network Services
- Load Balancing
  - Create Load Balancer
    - HTTP(S) Load Balancing >>> Start Configuration
      - Internet facing or internal only : From Internet to my VMs or serverless services
      - Global or Regional : Global HTTP(S) Load Balancer (classic)
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

        - Host and path rules
        - Review and finalize
        
        
        
  - Create        
        
        
        
        
        
        
        
        
        
        
        
        
        
        


