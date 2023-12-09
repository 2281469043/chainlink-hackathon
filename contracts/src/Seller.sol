// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {OwnerIsCreator} from "@chainlink/contracts-ccip/src/v0.8/shared/access/OwnerIsCreator.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {LinkTokenInterface} from "@chainlink/contracts-ccip/src/v0.8/shared/interfaces/LinkTokenInterface.sol";
import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";

contract Seller is OwnerIsCreator, CCIPReceiver {
    // Event emitted when a message is received from another chain.
    struct Signature{
        uint64 R8x;
        uint64 R8y;
        uint64 S;
    }

    struct PublicKey{
        uint64 Ax;
        uint64 Ay;
    }

    struct Order {
        PublicKey sellerPubkey;
        uint64 encryptedAmount;
        Signature amountSignedBySeller;
    }

    event MessageReceived(
        bytes32 indexed messageId, // The unique ID of the message.
        uint64 indexed sourceChainSelector, // The chain selector of the source chain.
        address sender, // The address of the sender from the source chain.
        string text // The text that was received.
    );

    event MessageSent(
        address receiver, // The address of the sender from the source chain.
        string text // The text that was received.
    );
    
    bytes32 private lastReceivedMessageId; // Store the last received messageId.
    string private lastReceivedMessage; // Store the last received text.
    LinkTokenInterface link;
    IRouterClient router;
    uint64 publicKey;
    mapping(bytes32 => Order) orderBook;

    constructor(address _router, address _link) CCIPReceiver(address(router)) {
        link = LinkTokenInterface(_link);
        router = IRouterClient(_router);
        link.approve(address(router), type(uint256).max);
    }
    
    function send(address receiver, string memory someText, uint64 destinationChainSelector) external {
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(receiver),
            data: abi.encode(someText),
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: "",
            feeToken: address(link)
        });

        IRouterClient(router).ccipSend(destinationChainSelector, message);

        emit MessageSent(
            abi.decode(message.receiver, (address)), // abi-decoding of the sender address,
            abi.decode(message.data, (string))
        );
    }
    
    // receives the message from the buyer for a set amount of purchase
    function _ccipReceive(
        Client.Any2EVMMessage memory any2EvmMessage
    ) internal override{
        lastReceivedMessageId = any2EvmMessage.messageId; // fetch the messageId
        lastReceivedMessage = abi.decode(any2EvmMessage.data, (string)); // abi-decoding of the sent text

        emit MessageReceived(
            any2EvmMessage.messageId,
            any2EvmMessage.sourceChainSelector, // fetch the source chain identifier (aka selector)
            abi.decode(any2EvmMessage.sender, (address)), // abi-decoding of the sender address,
            abi.decode(any2EvmMessage.data, (string))
        );

        // add to the order book
        orderBook[any2EvmMessage.messageId] = abi.decode(any2EvmMessage.data, (Order));
    }
}


