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
