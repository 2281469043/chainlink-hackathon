// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

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

contract TestSendOrderOnlyAddress is Script, Helper {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        bytes32 messageId = Buyer(
            vm.envAddress("BUYER_CONTRACT_ADDRESS")
        ).testCCIPRealV2(
            vm.envAddress("SELLER_CONTRACT_ADDRESS"),
            chainIdEthereumSepolia
        );

        console2.log(
            "You can now monitor the status of your Chainlink CCIP Message via https://ccip.chain.link using CCIP Message ID: "
        );
        console2.logBytes32(messageId);

        vm.stopBroadcast();
    }
}

contract TestSendOrderStr is Script, Helper {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        bytes32 messageId = Buyer(
            vm.envAddress("BUYER_CONTRACT_ADDRESS")
        ).testCCIPStr(
            vm.envAddress("SELLER_CONTRACT_ADDRESS"),
            chainIdEthereumSepolia
        );

        console2.log(
            "You can now monitor the status of your Chainlink CCIP Message via https://ccip.chain.link using CCIP Message ID: "
        );
        console2.logBytes32(messageId);

        vm.stopBroadcast();
    }
}

contract TestSendOrderOneInput is Script, Helper {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        bytes32 messageId = Buyer(
            vm.envAddress("BUYER_CONTRACT_ADDRESS")
        ).testCCIPRealV3(
            vm.envAddress("SELLER_CONTRACT_ADDRESS"),
            chainIdEthereumSepolia,
            11112312
        );

        console2.log(
            "You can now monitor the status of your Chainlink CCIP Message via https://ccip.chain.link using CCIP Message ID: "
        );
        console2.logBytes32(messageId);

        vm.stopBroadcast();
    }
}

contract TestSendOrder is Script, Helper {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        bytes32 messageId = Buyer(
            vm.envAddress("BUYER_CONTRACT_ADDRESS")
        ).sendOrder(
            vm.envAddress("SELLER_CONTRACT_ADDRESS"),
            chainIdEthereumSepolia,
            1,
            2,
            3,
            4,
            5,
            6
            // payFeesIn
        );

        console2.log(
            "You can now monitor the status of your Chainlink CCIP Message via https://ccip.chain.link using CCIP Message ID: "
        );
        console2.logBytes32(messageId);

        vm.stopBroadcast();
    }
}
