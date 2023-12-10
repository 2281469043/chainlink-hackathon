// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {OwnerIsCreator} from "@chainlink/contracts-ccip/src/v0.8/shared/access/OwnerIsCreator.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {LinkTokenInterface} from "@chainlink/contracts-ccip/src/v0.8/shared/interfaces/LinkTokenInterface.sol";
import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";

/**
 * A contract that represents the functionality of a Buyer in a supply-chain context, where there are some 
 secret information (the amount of supply) to be send to the seller that is operating in another chain.
 */
contract Buyer is OwnerIsCreator, CCIPReceiver {

    struct Order {
        uint256 Ax;
        uint256 Ay;
        uint256 S;
        uint256 R8x;
        uint256 R8y;
        uint256 encryptedAmount;
    }

    IRouterClient router;
    LinkTokenInterface linkToken;

    mapping(uint64 => bool) public whitelistedChains;
    mapping(bytes32 => Order) public requestedOrders;

    error NotEnoughBalance(uint256 currentBalance, uint256 calculatedFees); 
    error DestinationChainNotWhitelisted(uint64 destinationChainSelector);
    error NothingToWithdraw();
    error FailedToWithdrawEth(address owner, address target, uint256 value); // Used when the withdrawal of Ether fails.
    error DestinationChainNotAllowlisted(uint64 destinationChainSelector); // Used when the destination chain has not been allowlisted by the contract owner.
    error SourceChainNotAllowlisted(uint64 sourceChainSelector); // Used when the source chain has not been allowlisted by the contract owner.
    error SenderNotAllowlisted(address sender); // Used when the sender has not been allowlisted by the contract owner.

    event OrderInfoSent(
        bytes32 indexed messageId,
        uint64 destinationChainSelector,
        address indexed receiver,
        uint256 Ax,
        uint256 Ay,
        uint256 encryptedAmount,
        uint256 S,
        uint256 R8x,
        uint256 R8y
    );
    
    event Saysomething(
        bytes32 data
    );
    
    modifier onlyWhitelistedChain(uint64 _destinationChainSelector) {
        if (!whitelistedChains[_destinationChainSelector])
            revert DestinationChainNotWhitelisted(_destinationChainSelector);
        _;
    }

    constructor(address _router, address _link) CCIPReceiver(_router) {
        router = IRouterClient(_router);
        linkToken = LinkTokenInterface(_link);
    }

    function whitelistChain(uint64 _destinationChainSelector) external onlyOwner {
        whitelistedChains[_destinationChainSelector] = true;
    }

    function denylistChain(uint64 _destinationChainSelector) external onlyOwner {
        whitelistedChains[_destinationChainSelector] = false;
    }
    
    function testCCIPStrNoEncode(
        address sellerAddress,
        uint64 sellerChainSelector
    ) 
        external
        onlyOwner
        // onlyWhitelistedChain(sellerChainSelector)
        returns (bytes32 messageId) 
    {
        // Prepare the CCIP message
        Client.EVM2AnyMessage memory ccipMessage = Client.EVM2AnyMessage({
            receiver: abi.encode(sellerAddress),
            data: "I am a test string",
            tokenAmounts: new Client.EVMTokenAmount[](0), // No token transfer
            // extraArgs: Client._argsToBytes(
            //     Client.EVMExtraArgsV1({gasLimit: 2_000_000})
            // ),
            extraArgs: "",
            feeToken: address(linkToken)
        });

        // Calculate and verify the CCIP fees
        uint256 ccipFees = router.getFee(sellerChainSelector, ccipMessage);
        if (ccipFees > linkToken.balanceOf(address(this))) {
            revert NotEnoughBalance(linkToken.balanceOf(address(this)), ccipFees);
        }

        // Approve and process the CCIP fee payment
        linkToken.approve(address(router), ccipFees);

        // Initiate the CCIP order information transfer
        messageId = router.ccipSend(sellerChainSelector, ccipMessage); 

        // Emit an event to log the order info sending details
        emit Saysomething(
            "I sent a test message"
        );
    }

    function testCCIPStr(
        address sellerAddress,
        uint64 sellerChainSelector,
        string calldata inputStr
    ) 
        external
        onlyOwner
        // onlyWhitelistedChain(sellerChainSelector)
        returns (bytes32 messageId) 
    {
        // Prepare the CCIP message
        Client.EVM2AnyMessage memory ccipMessage = Client.EVM2AnyMessage({
            receiver: abi.encode(sellerAddress),
            // data: "I am a test string",
            data: abi.encode(inputStr),
            tokenAmounts: new Client.EVMTokenAmount[](0), // No token transfer
            // extraArgs: Client._argsToBytes(
            //     Client.EVMExtraArgsV1({gasLimit: 400_000})
            // ),
            extraArgs: "",
            feeToken: address(linkToken)
        });

        // Calculate and verify the CCIP fees

        // uint256 ccipFees = router.getFee(sellerChainSelector, ccipMessage);
        // if (ccipFees > linkToken.balanceOf(address(this))) {
        //     revert NotEnoughBalance(linkToken.balanceOf(address(this)), ccipFees);
        // }

        // Approve and process the CCIP fee payment
        linkToken.approve(address(router), type(uint256).max);

        // Initiate the CCIP order information transfer
        messageId = router.ccipSend(sellerChainSelector, ccipMessage); 

        // Emit an event to log the order info sending details
        emit Saysomething(
            "I sent a test message"
        );
    }

    function testCCIPArgsNoInput(
        address sellerAddress,
        uint64 sellerChainSelector
    ) 
        external
        onlyOwner
        // onlyWhitelistedChain(sellerChainSelector)
        returns (bytes32 messageId) 
    {
        bytes memory encodedOrderInfo = abi.encode(
            11,
            1,
            1212312,
            12,
            14,
            12312312
        );
        // Prepare the CCIP message
        Client.EVM2AnyMessage memory ccipMessage = Client.EVM2AnyMessage({
            receiver: abi.encode(sellerAddress),
            data: encodedOrderInfo,
            tokenAmounts: new Client.EVMTokenAmount[](0), // No token transfer
            // extraArgs: Client._argsToBytes(
            //     Client.EVMExtraArgsV1({gasLimit: 2_000_000})
            // ),
            extraArgs: "",
            feeToken: address(linkToken)
        });

        // Calculate and verify the CCIP fees
        // uint256 ccipFees = router.getFee(sellerChainSelector, ccipMessage);
        // if (ccipFees > linkToken.balanceOf(address(this))) {
        //     revert NotEnoughBalance(linkToken.balanceOf(address(this)), ccipFees);
        // }

        // Approve and process the CCIP fee payment
        linkToken.approve(address(router), type(uint256).max);

        // Initiate the CCIP order information transfer
        messageId = router.ccipSend(sellerChainSelector, ccipMessage); 

        // Emit an event to log the order info sending details
        emit Saysomething(
            "I sent a test message"
        );
    }

    function testCCIPArgs(
        address sellerAddress,
        uint64 sellerChainSelector,
        uint256 i,
        uint256 ii,
        uint256 iii,
        uint256 iiii
    ) 
        external
        onlyOwner
        // onlyWhitelistedChain(sellerChainSelector)
        returns (bytes32 messageId) 
    {
        bytes memory encodedOrderInfo = abi.encode(
            11,
            1,
            i,
            ii,
            iii,
            iiii
        );
        // Prepare the CCIP message
        Client.EVM2AnyMessage memory ccipMessage = Client.EVM2AnyMessage({
            receiver: abi.encode(sellerAddress),
            data: encodedOrderInfo,
            tokenAmounts: new Client.EVMTokenAmount[](0), // No token transfer
            // extraArgs: Client._argsToBytes(
            //     Client.EVMExtraArgsV1({gasLimit: 2_000_000})
            // ),
            extraArgs: "",
            feeToken: address(linkToken)
        });

        // Calculate and verify the CCIP fees
        // uint256 ccipFees = router.getFee(sellerChainSelector, ccipMessage);
        // if (ccipFees > linkToken.balanceOf(address(this))) {
        //     revert NotEnoughBalance(linkToken.balanceOf(address(this)), ccipFees);
        // }

        // Approve and process the CCIP fee payment
        linkToken.approve(address(router), type(uint256).max);

        // Initiate the CCIP order information transfer
        messageId = router.ccipSend(sellerChainSelector, ccipMessage); 

        // Emit an event to log the order info sending details
        emit Saysomething(
            "I sent a test message"
        );
    }
   
    /*
        Sends order information to a specified destination chain using CCIP
    */
    function sendOrder(
        address sellerAddress,
        uint64 sellerChainSelector,
        uint256 pubkeyAx,
        uint256 pubkeyAy,
        uint256 encryptedAmount,
        uint256 signatureS, 
        uint256 signatureR8x,
        uint256 signatureR8y
    ) 
        external
        onlyOwner
        // onlyWhitelistedChain(sellerChainSelector)
        returns (bytes32 messageId) 
    {
        // Encode the order information
        bytes memory encodedOrderInfo = abi.encode(
            pubkeyAx,
            pubkeyAy,
            signatureS,
            signatureR8x,
            signatureR8y,
            encryptedAmount
        );

        // Prepare the CCIP message
        Client.EVM2AnyMessage memory ccipMessage = Client.EVM2AnyMessage({
            receiver: abi.encode(sellerAddress),
            data: encodedOrderInfo,
            tokenAmounts: new Client.EVMTokenAmount[](0), // No token transfer
            extraArgs: "",
            // extraArgs: Client._argsToBytes(
            //     Client.EVMExtraArgsV1({gasLimit: 2_000_000})
            // ),
            feeToken: address(linkToken)
        });

        // Calculate and verify the CCIP fees
        // uint256 ccipFees = router.getFee(sellerChainSelector, ccipMessage);
        // if (ccipFees > linkToken.balanceOf(address(this))) {
        //     revert NotEnoughBalance(linkToken.balanceOf(address(this)), ccipFees);
        // }

        // Approve and process the CCIP fee payment
        linkToken.approve(address(router), type(uint256).max);

        // Initiate the CCIP order information transfer
        messageId = router.ccipSend(sellerChainSelector, ccipMessage); 

        // Emit an event to log the order info sending details
        // emit OrderInfoSent(
        //     messageId,
        //     sellerChainSelector,
        //     sellerAddress,
        //     pubkeyAx,
        //     pubkeyAy,
        //     encryptedAmount,
        //     signatureS,
        //     signatureR8x,
        //     signatureR8y
        // );
    }

    function _ccipReceive(
        Client.Any2EVMMessage memory any2EvmMessage
    ) internal override {
        
        //
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
        uint256 amount = LinkTokenInterface(_token).balanceOf(address(this));
        // Revert if there is nothing to withdraw
        if (amount == 0) revert NothingToWithdraw();
        LinkTokenInterface(_token).transfer(_beneficiary, amount);
    }
}
