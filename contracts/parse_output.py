import json

output = json.load(open('./broadcast/DeployBuyer.s.sol/97/run-latest.json'))
buyer_addr = output['receipts'][0]['contractAddress']

output = json.load(open('./broadcast/DeploySeller.s.sol/11155111/run-latest.json'))
seller_addr = output['receipts'][0]['contractAddress']

envfile = open('.env').readlines()

envfile = [line for line in envfile if not line.startswith('BUYER_ADDR=') or not line.startswith('SELLER_ADDR=')]
envfile += ["BUYER_ADDR=" + buyer_addr+"\n", "SELLER_ADDR=" + seller_addr+"\n"]

open('.env','w').writelines(envfile)