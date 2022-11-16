# Simple HTTP Load Balancer in Google Cloud Platform

### Compute Engine
    1. Instance Groups
    2. Create Instance Group
    3. New managed instance group (stateless)
       - Name : lb-group-example
       - Description : load balancer instance group
       - Instance template
         - Create a new Instance template
		
- Location : Single zone (choose cheapest)
- Autoscaling : On add and remove instance to the group
  Minimum (2) Maximum (5)
- Autoscaling metrics : CPU utilization 60%



#! /bin/bash
sudo apt-get update
sudo apt-get install apache2 -y
sudo a2ensite default-ssl
sudo a2enmod ssl
vm_hostname="$(curl -s -H "Metadata-Flavor:Google" http://metadata/computeMetadata/v1/instance/name)"
sudo echo "Page load balancer served from: $vm_hostname" | \
sudo tee /var/www/html/index.html
sudo systemctl restart apache2
