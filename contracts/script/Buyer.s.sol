// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {LinkTokenInterface} from "@chainlink/contracts-ccip/src/v0.8/shared/interfaces/LinkTokenInterface.sol";
import {Helper} from "../src/Helper.sol";
import {Buyer} from "../src/Buyer.sol";

contract LoadBuyer is Script, Helper {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        LinkTokenInterface(linkBscTestnet).transfer(
            vm.envAddress("BUYER_CONTRACT_ADDRESS"), 
            1000000000000000000
        );

        vm.stopBroadcast();
    }
}

contract DrainBuyer is Script, Helper {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Buyer(
            vm.envAddress("BUYER_CONTRACT_ADDRESS")
        ).withdrawToken(
            vm.envAddress("OWNER_ADDR"),
            linkBscTestnet
        );
        vm.stopBroadcast();
    }
}

contract TestBuyer is Script, Helper {
    // enum OperationType{ 
    //     MESSAGE, 
    //     REQUEST_PUBKEY,
    //     PROVIDE_PUBKEY,
    //     REQUEST_PROOF,
    //     PROVIDE_PROOF
    // }

    // struct CircomPubkey {
    //     uint256 Ax;
    //     uint256 Ay;
    // }

    // struct EthPubkey {
    //     bytes32 value;
    // }

    // struct TradeMessage {
    //     OperationType operation;
    //     CircomPubkey circomPubkey;
    //     EthPubkey ethPubkey;
    //     bytes encryptedRequest;
    //     string message;
    //     bytes proof;
    // }

    // CircomPubkey circomPubkey;
    // EthPubkey ethPubkey;
    // LinkTokenInterface link;
    // IRouterClient router;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        Buyer buyer = Buyer(vm.envAddress("BUYER_CONTRACT_ADDRESS"));
        
        // buyer.whitelistChain(chainIdBscTestnet);
        buyer.setCircomPubkey(12123123, 324234234);

        // buyer.provideCircomPubkey(
        //     vm.envAddress("SELLER_CONTRACT_ADDRESS"),
        //     chainIdEthereumSepolia
        // );

        // emulate the Eth key
        // buyer.setEthPubkey("asdfasdf");

        buyer.requestSupplyProof(
            vm.envAddress("SELLER_CONTRACT_ADDRESS"),
            chainIdEthereumSepolia,
            ""
        );

        // console2.log("testing proof");
        // bool proofgood = buyer.verifyProof(
        //     vm.envBytes("PROOF")
        // );

        // console2.log("proofgood", proofgood);
        
        vm.stopBroadcast();
    }
}


contract TestScript is Script, Helper {

    enum OperationType{ 
        MESSAGE, 
        REQUEST_PUBKEY,
        PROVIDE_PUBKEY,
        REQUEST_PROOF,
        PROVIDE_PROOF
    }
    
    struct CircomPubkey {
        uint256 Ax;
        uint256 Ay;
    }

    struct EthPubkey {
        bytes32 value;
    }

    struct TradeMessage {
        OperationType operation;
        CircomPubkey circomPubkey;
        EthPubkey ethPubkey;
        // uint256 Ax;
        // uint256 Ay;
        bytes encryptedRequest;
        string message;
        bytes proof;
    }

    CircomPubkey circomPubkey;
    EthPubkey ethPubkey;

    function sendTradeMessage(
        address recipient,
        uint64 recipientChainId,
        TradeMessage memory payload
    )
        internal
        // onlyOwner
        // onlyWhitelistedChain(sellerChainSelector)
        returns (bytes32 messageId) 
    {
        console2.log("entered");

        IRouterClient router = IRouterClient(routerBscTestnet);
        LinkTokenInterface link = LinkTokenInterface(linkBscTestnet);
        // Prepare the CCIP message
        Client.EVM2AnyMessage memory ccipMessage = Client.EVM2AnyMessage({
            receiver: abi.encode(recipient),
            data: abi.encode(payload),
            // data: abi.encode(message),
            tokenAmounts: new Client.EVMTokenAmount[](0), // No token transfer
            extraArgs: "",
            feeToken: address(link)
        });
        
        console2.log('constructed message');

        // Calculate and verify the CCIP fees
        uint256 ccipFees = router.getFee(recipientChainId, ccipMessage);
        console2.log("we got here!");
    }

    function run() public {
        ethPubkey = EthPubkey("");
        sendTradeMessage(
            vm.envAddress("SELLER_CONTRACT_ADDRESS"),
            chainIdEthereumSepolia,
            TradeMessage({
                operation: OperationType.REQUEST_PROOF,
                ethPubkey: ethPubkey,
                circomPubkey: circomPubkey,
                encryptedRequest:"",
                message:"",
                proof:""
            })
        );
    }
}
