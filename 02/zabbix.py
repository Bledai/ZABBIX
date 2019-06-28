import requests, json
import socket
from requests.auth import HTTPBasicAuth
import subprocess

hostip = subprocess.run("ip a |grep  inet.*eth1 | cut -d/ -f1 | grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*'",
                         shell=True, stdout=subprocess.PIPE).stdout.decode('utf-8')[:-1]
zabbix_server = '192.168.100.10'
zabbix_api_admin_name = "Admin"
zabbix_api_admin_password = "zabbix"
namegroup = "CloudHosts"
hostname = socket.gethostname()


def post(request):
    headers = {'content-type': 'application/json-rpc'}
    print(json.dumps(request))
    return requests.post(
        f'http://{zabbix_server}:/zabbix/api_jsonrpc.php',
         data=json.dumps(request),
         headers=headers,
         auth=HTTPBasicAuth(zabbix_api_admin_name, zabbix_api_admin_password)
    )


auth_token = post({
    "jsonrpc": "2.0",
    "method": "user.login",
    "id": 1,
    "auth": None,
    "params": {
         "user": zabbix_api_admin_name,
         "password": zabbix_api_admin_password
     }

    }
).json()["result"]


def group_create(namegroup, auth_token):
    return post({
    "jsonrpc": "2.0",
    "method": "hostgroup.create",
    "params": {
        "name": namegroup
    },
    "auth": auth_token,
    "id": 1
        }).json()["result"]["groupids"]


group_id = group_create(namegroup, auth_token)

template_id = post({
    "jsonrpc": "2.0",
    "method": "template.get",
    "params": {
        "output": "extend",
        "filter": {
            "host": [
                "Template OS Linux"
            ]
        }
    },
    "auth": auth_token,
    "id": 1
}).json()['result'][0]['templateid']


def register_host(hostname, hostip, group_id, template_id, auth_token):
    post({
    "jsonrpc": "2.0",
    "method": "host.create",
    "params": {
        "host": hostname,
        "interfaces": [
            {
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": hostip,
                "dns": "",
                "port": "10050"
            }
        ],
        "groups": [
            {
                "groupid": group_id[0]
            }
        ],
        "templates": [
            {
                "templateid": template_id
            }
        ],
        "inventory_mode": 0,
        "inventory": {
            "macaddress_a": "01234",
            "macaddress_b": "56768"
        }
    },
    "auth": auth_token,
    "id": 1
    })


register_host(hostname, hostip, group_id, template_id, auth_token)
