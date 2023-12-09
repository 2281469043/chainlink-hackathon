source .env

cast send $BUYER_ADDR --rpc-url $BSC_RPC_URL --private-key=$PRIVATE_KEY "sendOrder(address, uint64, uint256, uint256, uint256, uint256, uint256, uint256)" $SELLER_ADDR $SEPOLIA_CHAIN_SELECTOR 11 1 4 12 12 12312312

# cast send $BUYER_ADDR --rpc-url $BSC_RPC_URL --private-key=$PRIVATE_KEY "sayHello()"