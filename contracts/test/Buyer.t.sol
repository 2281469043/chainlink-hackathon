// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {LinkTokenInterface} from "@chainlink/contracts-ccip/src/v0.8/shared/interfaces/LinkTokenInterface.sol";
import {Helper} from "../src/Helper.sol";
import {Buyer} from "../src/Buyer.sol";

contract BuyerTest is Test,Helper {
    Buyer public buyer;
    
    function setUp() public {
        buyer = Buyer(vm.envAddress("BUYER_CONTRACT_ADDRESS"));
    }
    
    function testProvideCircomKey() public {
        // buyer.provideCircomPubkey();

        
    }
}

