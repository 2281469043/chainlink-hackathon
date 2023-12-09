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

    event OrderInfoSent(
        bytes32 indexed messageId,
        uint64 destinationChainSelector,
        address indexed receiver,
        uint256 Ax,
        uint256 Ay,
        uint256 encryptedAmount,
        uint256 S,
        uint256 R8x,
        uint256 R8y,
        uint256 ccipFees
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
        onlyWhitelistedChain(sellerChainSelector)
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
            extraArgs: Client._argsToBytes(
                Client.EVMExtraArgsV1({gasLimit: 0})
            ),
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
        emit OrderInfoSent(
            messageId,
            sellerChainSelector,
            sellerAddress,
            pubkeyAx,
            pubkeyAy,
            encryptedAmount,
            signatureS,
            signatureR8x,
            signatureR8y,
            ccipFees
        );
    }

    function _ccipReceive(
        Client.Any2EVMMessage memory any2EvmMessage
    ) internal override {
        
        //
    }
}
