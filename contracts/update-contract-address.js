const fs=require('fs');

if (process.argv.length < 3) {
  console.log('Please provide the path to the contract output file')
  process.exit(1)
}

if(process.argv[2] === 'buyer'){
  const buyerDeployOutput = require('./broadcast/DeployBuyer.s.sol/97/run-latest.json');
  const buyerContractAddress = buyerDeployOutput['receipts'][0]['contractAddress']

  let envFile = fs.readFileSync('./.env').toString().split('\n')
  for (let i = 0; i < envFile.length; i++) {
    if (envFile[i].includes('BUYER_CONTRACT_ADDRESS')) {
      envFile[i] = `BUYER_CONTRACT_ADDRESS=${buyerContractAddress}`
    }
  }

  fs.writeFileSync('./.env', envFile.join('\n'))
  console.log(`Buyer contract address updated to ${buyerContractAddress}`)
}
else if(process.argv[2] === 'seller'){
  const sellerDeployOutput = require('./broadcast/DeploySeller.s.sol/11155111/run-latest.json');
  const sellerContractAddress = sellerDeployOutput['receipts'][0]['contractAddress']

  let envFile = fs.readFileSync('./.env').toString().split('\n')
  for (let i = 0; i < envFile.length; i++) {
    if (envFile[i].includes('SELLER_CONTRACT_ADDRESS')) {
      envFile[i] = `SELLER_CONTRACT_ADDRESS=${sellerContractAddress}`
    }
  }

  fs.writeFileSync('./.env', envFile.join('\n'))
  console.log(`Seller contract address updated to ${sellerContractAddress}`)
}