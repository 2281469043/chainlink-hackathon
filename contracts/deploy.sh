source .env
forge script script/Buyer.s.sol:DeployBuyer --rpc-url $BSC_RPC_URL --broadcast -vvvvv
python parse_output.py

# forge script script/DeployDummy.s.sol:DeployDummy --fork-url $BSC_RPC_URL --broadcast -vvvvv