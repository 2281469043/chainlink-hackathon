// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

import {Seller} from "../src/Seller.sol";

contract DeploySeller is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address router = vm.envAddress("SEPOLIA_CCIP_ROUTER_ADDRESS");
        address link = vm.envAddress("SEPOLIA_CCIP_LINK_ADDRESS");
        vm.startBroadcast(deployerPrivateKey);
        
        Seller seller = new Seller(router, link);

        vm.stopBroadcast();
    }
}