import json

output = json.load(open('./broadcast/DeployBuyer.s.sol/97/run-latest.json'))
open('./buyer_contract.txt', 'w').write(
    output['receipts'][0]['contractAddress']
)

output = json.load(open('./broadcast/DeploySeller.s.sol/11155111/run-latest.json'))
open('./seller_contract.txt', 'w').write(
    output['receipts'][0]['contractAddress']
)
