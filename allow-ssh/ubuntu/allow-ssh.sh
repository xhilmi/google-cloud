# !/bin/bash
# ===============================================
# ============= SSH Ubuntu/Debian ===============
# ===============================================

sudo apt update -y;
sudo apt install git nano vim wget curl net-tools -y;

sudo sed -i 's/#Port .*/Port 64000/g' /etc/ssh/sshd_config;
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config;

sudo ufw allow 64000;
sudo ufw allow 22;
sudo ufw --force enable;
sudo ufw reload;

sudo service sshd restart;

sudo ls -lah;
