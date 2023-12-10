// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

import {Helper} from "../src/Helper.sol";
import {Buyer} from "../src/Buyer.sol";

contract DeployBuyer is Script, Helper {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address router = routerBscTestnet;
        address link = linkBscTestnet;
        vm.startBroadcast(deployerPrivateKey);
        
        Buyer buyer = new Buyer(router,link);
        buyer.whitelistChain(chainIdEthereumSepolia);

        vm.stopBroadcast();
    }
}