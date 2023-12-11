// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {LinkTokenInterface} from "@chainlink/contracts-ccip/src/v0.8/shared/interfaces/LinkTokenInterface.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {TradeEntity} from "./TradeEntity.sol";

contract Seller is TradeEntity {
    error NoSupplyProofRequested(); // Used when the sender has not been allowlisted by the contract owner.

    bool public isSupplyProofRequested;
    bytes32 private supplyProofRequestMessageId;

    constructor(address _router, address _link) TradeEntity(_router, _link) {}

    function provideEthPubkey(
        address buyerAddress,
        uint64 buyerChainId
    )
        public
        onlyWhitelistedChain(buyerChainId)
        returns (bytes32 messageId)
    {
        messageId = sendTradeMessage(
            buyerAddress,
            buyerChainId,
            TradeMessage({
                operation: OperationType.PROVIDE_PUBKEY,
                ethPubkey: ethPubkey,
                circomPubkey: circomPubkey,
                encryptedRequest: "",
                message: "",
                proof: ""
            })
        );
    }

    function setSupplyProofRequest(bytes32 messageId) internal {
        isSupplyProofRequested = true;
        supplyProofRequestMessageId = messageId;
    }

    function getSupplyProofRequestMessage()
        public
        view
        onlyOwner
        returns (TradeMessage memory)
    {
        if (isSupplyProofRequested) {
            return messageStack[supplyProofRequestMessageId];
        } else {
            revert NoSupplyProofRequested();
        }
    }

    function provideSupplyProof(
        address buyerAddress,
        uint64 buyerChainId,
        bytes memory proof
    ) public returns (bytes32 messageId) {
        messageId = sendTradeMessage(
            buyerAddress,
            buyerChainId,
            TradeMessage({
                operation: OperationType.PROVIDE_PUBKEY,
                ethPubkey: ethPubkey,
                circomPubkey: circomPubkey,
                encryptedRequest: "",
                message: "",
                proof: proof
            })
        );
    }

    // receives the message from the buyer for a set amount of purchase
    function _ccipReceive(
        Client.Any2EVMMessage memory any2EvmMessage
    )
        internal
        override
        onlyWhitelistedChain(any2EvmMessage.sourceChainSelector)
    {
        lastReceivedMessageId = any2EvmMessage.messageId; // fetch the messageId
        TradeMessage memory tradeMessage = abi.decode(
            any2EvmMessage.data,
            (TradeMessage)
        );

        messageStack[any2EvmMessage.messageId] = tradeMessage;

        address sender = abi.decode(any2EvmMessage.sender, (address));
        // uint64 senderChainId = any2EvmMessage.sourceChainSelector;

        emit MessageReceived(
            any2EvmMessage.messageId,
            any2EvmMessage.sourceChainSelector, // fetch the source chain identifier (aka selector)
            sender, // abi-decoding of the sender address,
            tradeMessage.operation,
            tradeMessage.message
        );

        // if(tradeMessage.operation==OperationType.REQUEST_PUBKEY){
        //     setCircomPubkey(tradeMessage.circomPubkey.Ax, tradeMessage.circomPubkey.Ay);
        //     // provideEthPubkey(sender, senderChainId);
        // } else if(tradeMessage.operation==OperationType.REQUEST_PROOF){
        //     setSupplyProofRequest(any2EvmMessage.messageId);
        // }
    }
}
