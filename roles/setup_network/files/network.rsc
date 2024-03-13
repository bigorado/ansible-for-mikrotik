/interface bridge add name=bridge1
/interface bridge port add bridge=bridge1 interface=ether2
/interface bridge port add bridge=bridge1 interface=ether3
/interface bridge port add bridge=bridge1 interface=ether4
/interface bridge port add bridge=bridge1 interface=ether5
/interface bridge port add bridge=bridge1 interface=ether6
/interface bridge port add bridge=bridge1 interface=ether7
/interface bridge port add bridge=bridge1 interface=ether8
/interface bridge port add bridge=bridge1 interface=ether9
/interface bridge port add bridge=bridge1 interface=ether10
/ip address add address=192.168.0.1/24 comment=defconf interface=bridge network=192.168.0.0
/ip pool add name=dhcp ranges=192.168.0.50-192.168.0.100
/ip dhcp-server add address-pool=dhcp interface=bridge lease-time=10m name=defconf
/ip dhcp-server network add address=192.168.0.0/24 dns-server=192.168.0.1,77.88.8.8,8.8.8.8 gateway=192.168.0.1 netmask=24
