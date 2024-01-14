README.md

Integrasi Server On-Premise dengan Server Cloud menggunakan Cloud VPN dan MikroTik IPsec untuk Peningkatan Keamanan Koneksi
        
Use Case:
- Kondisi existing Company X memiliki sebuah hybrid infrastructure, yakni Server On-Premise yang berlokasi pada Company X tersebut dan Server Cloud yang berada pada layanan Google Cloud.
- Server On-Premise dan Server Cloud saling terkoneksi menggunakan Public IP Address yang menjadi penyebab less secure dari segi security.
- Company X tetap aware terhadap Server Database yang tetap harus diletakkan secara On-Premise untuk kepentingan audit dan ingin koneksi antar Server menggunakan Private IP Address.

Approach:
- Possible approach adalah "Integrasi Server On-Premise dengan Server Cloud menggunakan Cloud VPN dan MikroTik IPsec untuk Peningkatan Keamanan Koneksi".
- Diharapkan koneksi antar Server menggunakan Internal IP Address untuk tetap dapat saling terbuhung namun lebih aman.

Requirement:
- Project A (thanos-onprem)
  - 1x MikrotikCHR VM v6.49 (OS Image + License Trial)
  - 1x Database Server VM (MySQL)
- Project B (thanos-cloud)
  - 1x Cloud VPN Classic
  - 1x Web Server VM (FrontEnd PHP CRUD)

Demo:
- Approach diatas akan dibangun pada layanan Google Cloud dengan 2 Project Google Cloud Platform (GCP) yang berbeda, sebagai contoh penamaan projectnya adalah (thanos-onprem) dan (thanos-cloud).
  - Project A (thanos-onprem)
    - Terdapat 1x VM MikrotikCHR v6.49 yang berperan sebagai IPsec Tunnel.
    - Terdapat 2x Network Ethernert, Eth-1 ke Internet dan Eth-2 ke VM-Database menggunakan Private IP Address.
    - Terdapat firewall pada Network Layer disisi Mikrotik, dengan konsep Masquerade untuk allow IP Address secara specific.
    - Terdapat 1x VM sebagai Database Server MySQL tanpa Public IP Address.
  - Project B (thanos-cloud)
    - Terdapat 1x VM aplikasi FrontEnd seperti PHP dengan Public IP Address dan Private IP Address.
    - Terdapat 1x Cloud VPN menggunakan Hybrid Connectivity menggunakan konsep Classic VPN, untuk Network Gateway ke MikrotikCHR.                

Conclusion:
- Kedua koneksi antar server teranulir oleh CloudVPN dan MikrotikCHR secara aman, dimana Public IP Address VM-Database tidak dapat terbaca langsung secara public.
- Sehingga kemungkinan seperti sniffing, bruteforce, DDOS, dan kejahatan cyber lainnya dapat terjaga.

Installation Cloud (Singapore) asia-southeast1:
1. Membuat custom VPC dengan subnet (172.16.10.0/24)
   ## vpc-cloud
   gcloud compute networks create vpc-cloud \
     --project="thanos-cloud" \
     --description="vpc-cloud" \
     --subnet-"mode=custom" \
     --mtu=1460 \
     --bgp-routing-mode="regional"
   ## subnet-cloud
   gcloud compute networks subnets create subnet-cloud \
     --project="thanos-cloud" \
     --description="subnet-cloud" \
     --range=172.16.10.0/24 \
     --stack-type=IPV4_ONLY \
     --network="vpc-cloud" \
     --region="asia-southeast1" \
     --enable-private-ip-google-access
2. Membuat firewall rule untuk memfilter port mana saja yang diizinkan lalu membuat spesifik tag target ke vm mana saja4. x
   ## firewall-cloud
   gcloud compute firewall-rules create firewall-cloud \
     --project="thanos-cloud" \
     --description="firewall-cloud" \
     --direction=INGRESS \
     --priority=100 \
     --network="vpc-cloud" \
     --action=ALLOW \
     --rules=tcp:20,tcp:21,tcp:22,tcp:80,tcp:443,tcp:888,tcp:3306,tcp:7800,tcp:8291,icmp \
     --source-ranges=0.0.0.0/0 \
     --target-tags="firewall-cloud"
3. Membuat IP External Static dan IP Internal Static untuk web-server
   ## ip-external-web-server
   gcloud compute addresses create ip-external-web-server \
     --project="thanos-cloud" \
     --description="ip-external-web-server" \
     --region="asia-southeast1"
   ## ip-internal-web-server
   gcloud compute addresses create ip-internal-web-server \
     --project="thanos-cloud" \
     --description="ip-internal-web-server" \
     --addresses=172.16.10.10 \
     --region="asia-southeast1" \
     --subnet="subnet-cloud" \
     --purpose=GCE_ENDPOINT
4. Membuat IP External Static untuk cloud-vpn
   ## ip-external-cloud-vpn
   gcloud compute addresses create ip-external-cloud-vpn \
     --project="thanos-cloud" \
     --description="ip-external-cloud-vpn" \
     --region="asia-southeast1"
5. Membuat web-server menggunakan OS Ubuntu 22.04 LTS
   ## web-server
   gcloud compute instances create web-server \
     --project="thanos-cloud" \
     --zone="asia-southeast1-a" \
     --machine-type="e2-medium" \
     --network-interface=address=(ip-public-web-server),network-tier=PREMIUM,private-network-ip=172.16.10.10,stack-type=IPV4_ONLY,subnet=subnet-cloud \
     --boot-disk-type "pd-balanced" \
     --boot-disk-size=20 \
     --image-project="ubuntu-os-cloud" \
     --image-family="ubuntu-2204-lts" \
     --tags="firewall-cloud" \
     --can-ip-forward
6. Melakukan konfigurasi pada web-server
   ## SSH into web-server
   gcloud compute ssh --zone "asia-southeast1-a" "web-server" --project "thanos-cloud"
   ## Install aaPanel (https://www.aapanel.com/new/download.html?btwaf=11481464) + MySQL-client
   sudo su -
   apt update
   apt install mysql-client -y
   wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && sudo bash install.sh aapanel
7. Membuat Cloud VPN    
   ## vpn-gateway
   gcloud compute target-vpn-gateways create vpn-gateway \
     --project="thanos-cloud" \
     --description="vpn-gateway" \
     --region="asia-southeast1" \
     --network="vpc-cloud"
   ## forwarding-rules
   gcloud compute forwarding-rules create forwarding-rules-esp \
     --project="thanos-cloud" \
     --region="asia-southeast1" \
     --address=(ip-public-cloud-vpn) \
     --ip-protocol=ESP \
     --target-vpn-gateway="vpn-gateway"
   gcloud compute forwarding-rules create forwarding-rules-udp500 \
     --project="thanos-cloud" \
     --region="asia-southeast1" \
     --address=(ip-public-cloud-vpn) \
     --ip-protocol=UDP \
     --ports=500 \
     --target-vpn-gateway="vpn-gateway"
   gcloud compute forwarding-rules create forwarding-rules-udp4500 \
     --project="thanos-cloud" \
     --region="asia-southeast1" \
     --address=(ip-public-cloud-vpn) \
     --ip-protocol=UDP \
     --ports=4500 \
     --target-vpn-gateway="vpn-gateway"
   ## vpn-tunnel
   gcloud compute vpn-tunnels create vpn-tunnel \
     --project="thanos-cloud" \
     --description="vpn-tunnel" \
     --region="asia-southeast1" \
     --peer-address=(ip-public-mikrotik-server) \
     --shared-secret="H6EZ8iJ2TwD1qojjbVvL2mWyDkd71Z84" \
     --ike-version=2 \
     --local-traffic-selector=0.0.0.0/0 \
     --remote-traffic-selector=0.0.0.0/0 \
     --target-vpn-gateway="vpn-gateway"
   ## vpn-tunnel-route
   gcloud compute routes create vpn-tunnel-route-1 \
     --project="thanos-cloud" \
     --network="vpc-cloud" \
     --priority=100 \
     --destination-range=192.168.10.250/32 \
     --next-hop-vpn-tunnel="vpn-tunnel" \
     --next-hop-vpn-tunnel-region="asia-southeast1"
   gcloud compute routes create vpn-tunnel-route-2 \
     --project="thanos-cloud" \
     --network="vpc-cloud" \
     --priority=100 \
     --destination-range=192.168.10.10/32 \
     --next-hop-vpn-tunnel="vpn-tunnel" \
     --next-hop-vpn-tunnel-region="asia-southeast1"
8. Langkah terakhir kita membuat routes dari cloud ke onprem
   # routes-to-onprem
   gcloud beta compute routes create routes-to-onprem \
     --project="thanos-cloud" \
     --description="routes-to-onprem" \
     --network="vpc-cloud" \
     --priority=10 \
     --tags="firewall-cloud" \
     --destination-range=192.168.10.0/24 \
     --next-hop-vpn-tunnel="vpn-tunnel" \
     --next-hop-vpn-tunnel-region="asia-southeast1"









