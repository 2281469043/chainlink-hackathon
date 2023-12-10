// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {OwnerIsCreator} from "@chainlink/contracts-ccip/src/v0.8/shared/access/OwnerIsCreator.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {LinkTokenInterface} from "@chainlink/contracts-ccip/src/v0.8/shared/interfaces/LinkTokenInterface.sol";
import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import {IERC20} from "@chainlink/contracts-ccip/src/v0.8/vendor/openzeppelin-solidity/v4.8.0/contracts/token/ERC20/IERC20.sol";

contract Seller is OwnerIsCreator, CCIPReceiver {
    // Event emitted when a message is received from another chain.

    error NotEnoughBalance(uint256 currentBalance, uint256 calculatedFees); 
    error DestinationChainNotWhitelisted(uint64 destinationChainSelector);
    error NothingToWithdraw();
    error FailedToWithdrawEth(address owner, address target, uint256 value); // Used when the withdrawal of Ether fails.
    error DestinationChainNotAllowlisted(uint64 destinationChainSelector); // Used when the destination chain has not been allowlisted by the contract owner.
    error SourceChainNotAllowlisted(uint64 sourceChainSelector); // Used when the source chain has not been allowlisted by the contract owner.
    error SenderNotAllowlisted(address sender); // Used when the sender has not been allowlisted by the contract owner.

    struct Order {
        uint256 Ax;
        uint256 Ay;
        uint256 S;
        uint256 R8x;
        uint256 R8y;
        uint256 encryptedAmount;
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

    constructor(address _router, address _link) CCIPReceiver(_router) {
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

    /// @notice Allows the contract owner to withdraw the entire balance of Ether from the contract.
    /// @dev This function reverts if there are no funds to withdraw or if the transfer fails.
    /// It should only be callable by the owner of the contract.
    /// @param _beneficiary The address to which the Ether should be sent.
    function withdraw(address _beneficiary) public onlyOwner {
        // Retrieve the balance of this contract
        uint256 amount = address(this).balance;

        // Revert if there is nothing to withdraw
        if (amount == 0) revert NothingToWithdraw();

        // Attempt to send the funds, capturing the success status and discarding any return data
        (bool sent, ) = _beneficiary.call{value: amount}("");

        // Revert if the send failed, with information about the attempted transfer
        if (!sent) revert FailedToWithdrawEth(msg.sender, _beneficiary, amount);
    }

    /// @notice Allows the owner of the contract to withdraw all tokens of a specific ERC20 token.
    /// @dev This function reverts with a 'NothingToWithdraw' error if there are no tokens to withdraw.
    /// @param _beneficiary The address to which the tokens will be sent.
    /// @param _token The contract address of the ERC20 token to be withdrawn.
    function withdrawToken(
        address _beneficiary,
        address _token
    ) public onlyOwner {
        // Retrieve the balance of this contract
        uint256 amount = IERC20(_token).balanceOf(address(this));

        // Revert if there is nothing to withdraw
        if (amount == 0) revert NothingToWithdraw();

        IERC20(_token).transfer(_beneficiary, amount);
    }
}


