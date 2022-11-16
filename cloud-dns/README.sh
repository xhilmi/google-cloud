# Google Cloud Platform | Cloud DNS #

### Create Cloud DNS = Network Services
- Cloud DNS
  - Create a DNS zonw
    - Zone type : Public
    - Zone name : dns
    - DNS name : dns.example.com
    - DNSSEC : Off
    - Description : dns.example.com
  - Create

- Cloud DNS is succesfully has been setup. Now we want to connect using Google Cloud DNS Nameserver.
- If you have domain in others Registrar, simply point that domain into Cloudflare Nameserver first.
- Then setting Nameserver on menu DNS in Cloudflare into Google Cloud DNS Nameserver.
- Last step you could add your DNS Zone from Google Cloud DNS
