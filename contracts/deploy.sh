source .env

forge script script/DeployBuyer.s.sol:DeployBuyer --rpc-url $BSC_RPC_URL --broadcast -vvvvv 
node update-contract-address.js buyer
cp ./out/Buyer.sol/Buyer.json ../frontend/src/contracts/Buyer.json

forge script script/DeploySeller.s.sol:DeploySeller --rpc-url $ETH_RPC_URL --broadcast -vvvvv 
node update-contract-address.js buyer
cp ./out/Seller.sol/Seller.json ../frontend/src/contracts/Seller.json