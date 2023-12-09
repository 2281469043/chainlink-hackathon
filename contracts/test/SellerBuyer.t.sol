// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Seller} from "../src/Seller.sol";
import {Buyer} from "../src/Buyer.sol";

contract SellerTest is Test {
    Seller public seller;
    Buyer public buyer;

    function setUp() public {
        // seller lives on sepolia
        seller = new Seller(
            0x51441fD4acacCC9BDA38178244C13f1E4D1367Bd,
            0xb83E47C2bC239B3bf370bc41e1459A34b41238D0
        );

        // buyer lives on bnb
        buyer = new Buyer(
            0x51441fD4acacCC9BDA38178244C13f1E4D1367Bd,
            0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06
        );
    }
    
    function test_CCIP_send() public {
        Buyer.PublicKey memory publicKey = Buyer.PublicKey(0, 0);
        Buyer.Signature memory signature = Buyer.Signature(0, 0, 0);
        buyer.sendOrderInfoViaCCIP(
            97,
            address(seller),
            publicKey,
            80,
            signature
        );
        // assertEq(seller.number(), 1);
    }
}
