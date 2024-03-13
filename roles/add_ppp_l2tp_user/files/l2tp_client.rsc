/interface l2tp-client
add connect-to=SERVERADDR disabled=no name=NAME user=USER password=PASSWORD
/ip route
add disabled=no distance=1 dst-address=10.0.0.0/8 gateway=10.0.0.1 \
    pref-src="" routing-table=main scope=30 suppress-hw-offload=no \
    target-scope=10