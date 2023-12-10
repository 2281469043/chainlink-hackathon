source .env

forge script script/Buyer.s.sol:LoadBuyer --rpc-url $BSC_RPC_URL --broadcast -vvvvv

forge script script/Buyer.s.sol:TestSendOrder --rpc-url $BSC_RPC_URL --broadcast -vvvvv

forge script script/Buyer.s.sol:GetMoneyBack --fork-url $BSC_RPC_URL --broadcast -vvvvv

# cast send 0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06 "transfer(address,uint256)" $BUYER_CONTRACT_ADDRESS 10000000000000000 --rpc-url $BSC_RPC_URL --private-key=$PRIVATE_KEY

# cast send $BUYER_CONTRACT_ADDRESS --rpc-url $BSC_RPC_URL --private-key $PRIVATE_KEY "sendOrder(address, uint64, uint256, uint256, uint256, uint256, uint256, uint256)" $SELLER_CONTRACT_ADDRESS $SEPOLIA_CHAIN_SELECTOR 3 1 4 2 1 0

# cast send $BUYER_CONTRACT_ADDRESS --rpc-url $BSC_RPC_URL --private-key $PRIVATE_KEY "sayHello()"

# cast send $BUYER_CONTRACT_ADDRESS --rpc-url $BSC_RPC_URL --private-key $PRIVATE_KEY "testCCIP_1()"

# cast send $BUYER_CONTRACT_ADDRESS --rpc-url $BSC_RPC_URL --private-key $PRIVATE_KEY "testCCIPStrV1()"

# cast send $BUYER_CONTRACT_ADDRESS --rpc-url $BSC_RPC_URL --private-key $PRIVATE_KEY "testCCIPRealV2(address,uint64)" $SELLER_CONTRACT_ADDRESS $SEPOLIA_CHAIN_SELECTOR

# cast send $BUYER_CONTRACT_ADDRESS --rpc-url $BSC_RPC_URL --private-key=$PRIVATE_KEY "withdrawToken(address, address)" 0x51441fD4acacCC9BDA38178244C13f1E4D1367Bd 0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06


# cast send $BUYER_CONTRACT_ADDRESS --rpc-url $BSC_RPC_URL --private-key=$PRIVATE_KEY "withdrawToken(address, address)" 0x51441fD4acacCC9BDA38178244C13f1E4D1367Bd  0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06