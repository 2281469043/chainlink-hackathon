source .env

cast \ 
    send 0xF04E5403185E941E29b25af5599632Ec259e07B1 \
    --rpc-url $BSC_RPC_URL \
    --private-key=$PRIVATE_KEY \ 
    "send(address,string,uint64)" \
    <CCIP_RECEIVER_UNSAFE_ADDRESS> \ 
    "CCIP Masterclass" \
    16015286601757825753