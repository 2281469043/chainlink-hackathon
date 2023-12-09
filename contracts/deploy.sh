source .env
forge script script/DeployBuyer.s.sol:DeployBuyer --rpc-url $BSC_RPC_URL --broadcast -vvvvv
# forge script script/DeploySeller.s.sol:DeploySeller --rpc-url $SEPOLIA_RPC_URL --broadcast -vvvvv
python parse_output.py