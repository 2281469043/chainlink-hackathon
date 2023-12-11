// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {LinkTokenInterface} from "@chainlink/contracts-ccip/src/v0.8/shared/interfaces/LinkTokenInterface.sol";
import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import {LinkTokenInterface} from "@chainlink/contracts-ccip/src/v0.8/shared/interfaces/LinkTokenInterface.sol";
import {Helper} from "../src/Helper.sol";
import {Seller} from "../src/Seller.sol";

contract LoadSeller is Script, Helper {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        LinkTokenInterface(linkEthereumSepolia).transfer(
            vm.envAddress("SELLER_CONTRACT_ADDRESS"), 
            1000000000000000000
        );

        vm.stopBroadcast();
    }
}

contract DrainSeller is Script, Helper {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Seller(
            vm.envAddress("SELLER_CONTRACT_ADDRESS")
        ).withdrawToken(
            vm.envAddress("OWNER_ADDR"),
            linkEthereumSepolia
        );
        vm.stopBroadcast();
    }
}

contract TestSeller is  Script, Helper {
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
        bytes encryptedRequest;
        string message;
        bytes proof;
    }

    CircomPubkey circomPubkey;
    EthPubkey ethPubkey;
    LinkTokenInterface link;
    IRouterClient router;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        address buyerAddress = vm.envAddress("BUYER_CONTRACT_ADDRESS");
        uint64 buyerChainId = chainIdBscTestnet;

        Seller seller = Seller(vm.envAddress("SELLER_CONTRACT_ADDRESS"));
        seller.provideEthPubkey(buyerAddress, buyerChainId);

        // seller.provideSupplyProof(
        //     buyerAddress,
        //     buyerChainId,
        //     vm.envBytes("PROOF")
        // );
        
        // TradeMessage tradeMessage = TradeMessage({
        //     operation: OperationType.PROVIDE_PUBKEY,
        //     ethPubkey: ethPubkey,
        //     circomPubkey: circomPubkey,
        //     encryptedRequest:"",
        //     message:"",
        //     proof:""
        // });

        // Client.EVM2AnyMessage memory ccipMessage = Client.EVM2AnyMessage({
        //     receiver: abi.encode(buyerAddress),
        //     data: abi.encode(tradeMessage),
        //     // data: abi.encode(message),
        //     tokenAmounts: new Client.EVMTokenAmount[](0), // No token transfer
        //     extraArgs: "",
        //     feeToken: address(link)
        // });

        vm.stopBroadcast();
    }
}