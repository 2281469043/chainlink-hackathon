// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {OwnerIsCreator} from "@chainlink/contracts-ccip/src/v0.8/shared/access/OwnerIsCreator.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {LinkTokenInterface} from "@chainlink/contracts-ccip/src/v0.8/shared/interfaces/LinkTokenInterface.sol";
import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import {Groth16Verifier} from "./CanfillOrder_verifier.sol";
import {TradeEntity} from "./TradeEntity.sol";

contract Buyer is TradeEntity {
    constructor(address _router, address _link) TradeEntity(_router, _link) {
        verifier = address(new Groth16Verifier());
    }

    function provideCircomPubkey(
        address sellerAddress,
        uint64 sellerChainId
    )
        external
        onlyWhitelistedChain(sellerChainId)
        returns (bytes32 messageId)
    {
        messageId = sendTradeMessage(
            sellerAddress,
            sellerChainId,
            TradeMessage({
                operation: OperationType.REQUEST_PUBKEY,
                ethPubkey: ethPubkey,
                circomPubkey: circomPubkey,
                encryptedRequest: "",
                message: "",
                proof: ""
            })
        );
    }

    function requestSupplyProof(
        address sellerAddress,
        uint64 sellerChainId,
        bytes calldata encryptedMessage
    )
        external
        onlyOwner
        onlyWhitelistedChain(sellerChainId)
        returns (bytes32 messageId)
    {
        // Encode the order information
        messageId = sendTradeMessage(
            sellerAddress,
            sellerChainId,
            TradeMessage({
                operation: OperationType.REQUEST_PROOF,
                ethPubkey: ethPubkey,
                circomPubkey: circomPubkey,
                encryptedRequest: encryptedMessage,
                message: "",
                proof: ""
            })
        );
    }

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
        emit MessageReceived(
            any2EvmMessage.messageId,
            any2EvmMessage.sourceChainSelector, // fetch the source chain identifier (aka selector)
            abi.decode(any2EvmMessage.sender, (address)), // abi-decoding of the sender address,
            tradeMessage.operation,
            tradeMessage.message
        );
        // if(tradeMessage.operation==OperationType.PROVIDE_PUBKEY){
        //     setEthPubkey(tradeMessage.ethPubkey.value);

        // }else if(tradeMessage.operation==OperationType.PROVIDE_PROOF){
        //     verifyProof(tradeMessage.proof);
        // }else{
        //     revert UnknownOperation();
        // }
    }
}
