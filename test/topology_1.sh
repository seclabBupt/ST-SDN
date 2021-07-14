/usr/share/openvswitch/scripts/ovs-ctl start

ovs-vswitchd unix:/var/run/openvswitch/db.sock \
-vconsole:emer -vsyslog:err -vfile:info --mlockall --no-chdir \
--log-file=/var/log/openvswitch/ovs-vswitchd.log \
--pidfile=/var/run/openvswitch/ovs-vswitchd.pid \
--detach --monitor

ovsdb-server /etc/openvswitch/conf.db \
-vconsole:emer -vsyslog:err -vfile:info \
--remote=punix:/var/run/openvswitch/db.sock \
--private-key=db:Open_vSwitch,SSL,private_key \
--certificate=db:Open_vSwitch,SSL,certificate \
--bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert --no-chdir \
--log-file=/var/log/openvswitch/ovsdb-server.log \
--pidfile=/var/run/openvswitch/ovsdb-server.pid \
--detach --monitor

#创建网桥
ovs-vsctl add-br s1
ovs-vsctl add-br s2
ovs-vsctl add-br s3
ovs-vsctl add-br s4
ovs-vsctl add-br s5

#s1
ovs-vsctl add-port s1 s1s3
ovs-vsctl add-port s1 s1s4
ovs-vsctl add-port s1 s1s5
ovs-vsctl set Interface s1s3 type=patch options:peer=s3s1
ovs-vsctl set Interface s1s4 type=patch options:peer=s4s1
ovs-vsctl set Interface s1s5 type=patch options:peer=s5s1

#s2
ovs-vsctl add-port s2 s2s3
ovs-vsctl add-port s2 s2s4
ovs-vsctl add-port s2 s2s5
ovs-vsctl set Interface s2s3 type=patch options:peer=s3s2
ovs-vsctl set Interface s2s4 type=patch options:peer=s4s2
ovs-vsctl set Interface s2s5 type=patch options:peer=s5s2

#s3
ovs-vsctl add-port s3 s3s1
ovs-vsctl add-port s3 s3s2
ovs-vsctl set Interface s3s1 type=patch options:peer=s1s3
ovs-vsctl set Interface s3s2 type=patch options:peer=s2s3

#s4
ovs-vsctl add-port s4 s4s1
ovs-vsctl add-port s4 s4s2
ovs-vsctl set Interface s4s1 type=patch options:peer=s1s4
ovs-vsctl set Interface s4s2 type=patch options:peer=s2s4

#s5
ovs-vsctl add-port s5 s5s1
ovs-vsctl add-port s5 s5s2
ovs-vsctl set Interface s5s1 type=patch options:peer=s1s5
ovs-vsctl set Interface s5s2 type=patch options:peer=s2s5

ip netns add ns1
ip netns add ns2
ip link add tap1 type veth peer name ovs-tap1
ip link add tap2 type veth peer name ovs-tap2
ip link set tap1 netns ns1
ip link set tap2 netns ns2
ip netns exec ns1 ip addr add 192.168.0.11/24 dev tap1
ip netns exec ns2 ip addr add 192.168.0.12/24 dev tap2
ip netns exec ns1 ip link set tap1 up
ip netns exec ns2 ip link set tap2 up
ip link set ovs-tap1 up
ip link set ovs-tap2 up
ovs-vsctl add-port s1 ovs-tap1
ovs-vsctl add-port s1 ovs-tap2

ip netns add ns3
ip netns add ns4
ip link add tap3 type veth peer name ovs-tap3
ip link add tap4 type veth peer name ovs-tap4
ip link set tap3 netns ns3
ip link set tap4 netns ns4
ip netns exec ns3 ip addr add 192.168.0.13/24 dev tap3
ip netns exec ns4 ip addr add 192.168.0.14/24 dev tap4
ip netns exec ns3 ip link set tap3 up
ip netns exec ns4 ip link set tap4 up
ip link set ovs-tap3 up
ip link set ovs-tap4 up
ovs-vsctl add-port s2 ovs-tap3
ovs-vsctl add-port s2 ovs-tap4

ovs-vsctl set-controller s1 tcp:10.42.0.20:6653
ovs-vsctl set-controller s2 tcp:10.42.0.20:6653
ovs-vsctl set-controller s3 tcp:10.42.0.20:6653
ovs-vsctl set-controller s4 tcp:10.42.0.20:6653
ovs-vsctl set-controller s5 tcp:10.42.0.20:6653


ip netns exec ns1 ping -c3 192.168.0.12
ip netns exec ns1 ping -c3 192.168.0.13
ip netns exec ns1 ping -c3 192.168.0.14
