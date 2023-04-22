#!/bin/bash
# ===============================================
# =========== SSH Configuration Script ==========
# ===============================================

echo "Please choose your operating system:"
echo "1. CentOS"
echo "2. Ubuntu"
echo "3. Exit"

read -p "Enter your choice (1/2/3): " choice

case $choice in
  1)
    read -p "Enter the desired SSH port number: " port
    echo "Configuring SSH for CentOS..."
    sudo yum update -y > /dev/null 2>&1
    sudo yum provides *bin/semanage
    sudo yum install git nano vim wget curl net-tools policycoreutils-python-utils -y > /dev/null 2>&1
    sudo sed -i "s/.*Port .*/Port $port/g" /etc/ssh/sshd_config
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    sudo sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
    sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
    sudo yum install -y curl policycoreutils-python > /dev/null 2>&1
    sudo semanage port -a -t ssh_port_t -p tcp $port
    sudo firewall-cmd --permanent --add-port=$port/tcp
    sudo firewall-cmd --reload
    sudo systemctl enable firewalld
    sudo systemctl restart firewalld
    sudo service sshd restart
    sudo ls -lah
    ;;
  2)
    read -p "Enter the desired SSH port number: " port
    echo "Configuring SSH for Ubuntu/Debian..."
    sudo apt update -y > /dev/null 2>&1
    sudo apt install git nano vim wget curl net-tools -y > /dev/null 2>&1
    sudo sed -i "s/.*Port .*/Port $port/g" /etc/ssh/sshd_config
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
    sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
    sudo ufw allow $port
    sudo ufw --force enable
    sudo ufw reload
    sudo service sshd restart
    sudo service sshd status
    ;;
  3)
    echo "Exiting SSH configuration script."
    exit 0
    ;;
  *)
    echo "Invalid choice. Please try again."
    exit 1
    ;;
esac
