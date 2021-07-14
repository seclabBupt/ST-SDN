import requests, json, sys, re, time, os, warnings, argparse
from requests_toolbelt.multipart.encoder import MultipartEncoder

parser=argparse.ArgumentParser(description="Python script for creating a new flow table")
parser.add_argument('-mac',help='mac address of ovs', required=True)
parser.add_argument('-dst',help='mac address of destination', required=True)
parser.add_argument('-src',help='mac address of source', required=True)
parser.add_argument('-inport',help='inPort of ovs', required=True)
parser.add_argument('-outport',help='outPor of ovs', required=True)

args=vars(parser.parse_args())

mac = args["mac"]
dst = args["dst"]
src = args["src"]
inport = args["inport"]
outport = args["outport"]

def create_forward_flow():
    data = {"flows":[
               {
               "priority": 40000,
               "timeout": 0, 
               "isPermanent": True,
               "deviceId": "of:0000000000000000", 
               "treatment": {"instructions":[{"type": "OUTPUT", 
                                             "port": "0"}]},
               "selector": {"criteria":[{"type": "ETH_DST","mac": "0000"},
                                       {"type": "ETH_SRC","mac": "0000"},
                                       {"type": "IN_PORT","port": "0"}]}}]}
    data["flows"][0]["deviceId"] = mac
    data["flows"][0]["treatment"]["instructions"][0]["port"] = outport
    data["flows"][0]["selector"]["criteria"][0]["mac"] = dst
    data["flows"][0]["selector"]["criteria"][1]["mac"] = src
    data["flows"][0]["selector"]["criteria"][2]["port"] = inport
    data = json.dumps(data,sort_keys=True, indent=1, separators=(',', ': '))
    
    headers = {'content-type': 'application/json'}
    url = 'http://127.0.0.1:8181/onos/v1/flows?appId=org.onosproject.fwd'
    response = requests.post(url, data=data, headers=headers, verify=False,auth=('karaf', 'karaf'))
    print(response.text)

def create_backward_flow():
    data = {"flows":[
               {
               "priority": 40000,
               "timeout": 0, 
               "isPermanent": True,
               "deviceId": "of:0000000000000000", 
               "treatment": {"instructions":[{"type": "OUTPUT", 
                                             "port": "0"}]},
               "selector": {"criteria":[{"type": "ETH_DST","mac": "0000"},
                                       {"type": "ETH_SRC","mac": "0000"},
                                       {"type": "IN_PORT","port": "0"}]}}]}
    data["flows"][0]["deviceId"] = mac
    data["flows"][0]["treatment"]["instructions"][0]["port"] = inport
    data["flows"][0]["selector"]["criteria"][0]["mac"] = src
    data["flows"][0]["selector"]["criteria"][1]["mac"] = dst
    data["flows"][0]["selector"]["criteria"][2]["port"] = outport
    data = json.dumps(data,sort_keys=True, indent=1, separators=(',', ': '))
    
    headers = {'content-type': 'application/json'}
    url = 'http://127.0.0.1:8181/onos/v1/flows?appId=org.onosproject.fwd'
    response = requests.post(url, data=data, headers=headers, verify=False,auth=('karaf', 'karaf'))
    print(response.text)

if __name__ == "__main__":
    create_forward_flow()
    create_backward_flow()
