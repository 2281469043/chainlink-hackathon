// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

import {Buyer} from "../src/Buyer.sol";

contract DeployBuyer is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address router = vm.envAddress("BSC_CCIP_ROUTER_ADDRESS");
        address link = vm.envAddress("BSC_CCIP_LINK_ADDRESS");
        vm.startBroadcast(deployerPrivateKey);
        
        Buyer buyer = new Buyer(router,link);

        vm.stopBroadcast();
    }
}