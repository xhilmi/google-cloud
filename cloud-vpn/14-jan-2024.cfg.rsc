# jan/14/2024 05:47:31 by RouterOS 6.49.10
# software id = 
#
#
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip ipsec policy group
add name=cloud-vpn-group
/ip ipsec profile
add dh-group=modp1024 enc-algorithm=aes-128 name=cloud-vpn-profiles
/ip ipsec peer
add address=34.87.25.3/32 exchange-mode=ike2 name=cloud-vpn-peers profile=\
    cloud-vpn-profiles
/ip ipsec proposal
add auth-algorithms=sha256 enc-algorithms=aes-256-cbc name=cloud-vpn-proposal
/ip dhcp-client
add disabled=no interface=ether1
/ip ipsec identity
add peer=cloud-vpn-peers policy-template-group=cloud-vpn-group secret=\
    H6EZ8iJ2TwD1qojjbVvL2mWyDkd71Z84
/ip ipsec policy
add dst-address=172.16.10.0/24 peer=cloud-vpn-peers proposal=\
    cloud-vpn-proposal src-address=192.168.10.0/24 tunnel=yes
