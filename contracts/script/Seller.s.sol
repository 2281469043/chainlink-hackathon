// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

import {LinkTokenInterface} from "@chainlink/contracts-ccip/src/v0.8/shared/interfaces/LinkTokenInterface.sol";
import {Helper} from "../src/Helper.sol";
import {Buyer} from "../src/Buyer.sol";

contract LoadSeller is Script, Helper {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        
        LinkTokenInterface(linkEthereumSepolia).transfer(
            vm.envAddress("BUYER_CONTRACT_ADDRESS"), 
            1000000000000000000
        );

        vm.stopBroadcast();
    }
}

contract DrainSeller is Script, Helper {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Buyer(
            vm.envAddress("BUYER_CONTRACT_ADDRESS")
        ).withdrawToken(
            vm.envAddress("OWNER_ADDR"),
            linkEthereumSepolia
        );
        vm.stopBroadcast();
    }
}
