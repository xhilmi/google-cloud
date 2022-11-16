# !/bin/bash
# ===============================================
# ================= SSH Centos ==================
# ===============================================

sudo yum update -y;
sudo yum provides *bin/semanage;
sudo yum install git nano vim wget curl net-tools policycoreutils-python-utils -y;

sudo sed -i 's/#Port .*/Port 64000/g' /etc/ssh/sshd_config;
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config;

sudo semanage port -a -t ssh_port_t -p tcp 64000;
sudo firewall-cmd --permanent --add-port=6400/tcp;
sudo firewall-cmd --reload;

sudo systemctl enable firewalld;
sudo systemctl restart firewalld

sudo service sshd restart;

sudo ls -lah;
