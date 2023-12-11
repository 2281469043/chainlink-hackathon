// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

import {Helper} from "../src/Helper.sol";
import {Seller} from "../src/Seller.sol";

contract DeploySeller is Script, Helper {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address router = routerEthereumSepolia;
        address link = linkEthereumSepolia;
        vm.startBroadcast(deployerPrivateKey);
        
        Seller seller = new Seller(router, link);
        seller.setEthPubkey(
            vm.envBytes32("PUBLIC_KEY")
        );
        seller.whitelistChain(chainIdBscTestnet);
        seller.whitelistChain(chainIdEthereumSepolia);
        vm.stopBroadcast();
    }
    
}