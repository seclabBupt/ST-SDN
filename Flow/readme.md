## code for create flowtable
- 使用介绍
```bash
#各个节点的mac地址为：（具体的mac地址以及端口信息可以在onos gui中查看到，教程为了描述简便，以下参数均为假设）
#host1：000000000011    host2:000000000012
#ovs1: 000000000021    ovs2:000000000022    ovs3: 000000000032
#
#其中 ovs1 inport为1，outport为2；
#     ovs2 inport为2，outport为3；
#     ovs3 inport为3，outport为4.
#
#我们假设需要建立host1到host2的流表，路径如下：
#  host1 -> ovs1 -> ovs2 -> ovs3 -> host2

#ovs1
python3 create_flow_table.py -mac 000000000021 -dst 000000000012 -src 000000000011 -inport 1 -outport 2

#ovs2
python3 create_flow_table.py -mac 000000000022 -dst 000000000012 -src 000000000011 -inport 2 -outport 3

#ovs3
python3 create_flow_table.py -mac 000000000023 -dst 000000000012 -src 000000000011 -inport 3 -outport 4
```
