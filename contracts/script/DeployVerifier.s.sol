// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

import {Helper} from "../src/Helper.sol";
import {Groth16Verifier} from "../src/Verifier.sol";

contract DeploySeller is Script, Helper {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address router = routerEthereumSepolia;
        address link = linkEthereumSepolia;
        vm.startBroadcast(deployerPrivateKey);
        
        // Groth16Verifier seller = new Groth16Verifier(router, link);

        vm.stopBroadcast();
    }
    
}