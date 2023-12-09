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

    struct PublicKey{
        uint64 Ax;
        uint64 Ay;
    }

    struct Signature{
        uint64 S;
        uint64 R8x;
        uint64 R8y;
    }
 
    struct Order {
        PublicKey sellerPubkey;
        uint64 encryptedAmount;
        Signature amountSignedBySeller;
    }

    IRouterClient router;
    LinkTokenInterface linkToken;
    
    mapping(uint64 => bool) public whitelistedChains;
    mapping(address => Order) public sellers;
    
    error NotEnoughBalance(uint256 currentBalance, uint256 calculatedFees); 
    error DestinationChainNotWhitelisted(uint64 destinationChainSelector);
    error NothingToWithdraw();
    
    event OrderInfoSent(
        bytes32 indexed messageId,
        uint64 destinationChainSelector,
        address indexed receiver,
        PublicKey sellerPubkey,
        uint64 encryptedAmount,
        Signature amountSignedBySeller,
        uint256 ccipFees
    );
    
    modifier onlyWhitelistedChain(uint64 _destinationChainSelector) {
        if (!whitelistedChains[_destinationChainSelector])
            revert DestinationChainNotWhitelisted(_destinationChainSelector);
        _;
    }

    constructor(address _router, address _link) CCIPReceiver(address(router)) {
        router = IRouterClient(_router);
        linkToken = LinkTokenInterface(_link);
    }
   
    /**
     *   Function to set an order for a seller
     */
    function setOrder(
        address sellerAddress,
        uint64 pubkeyAx, uint64 pubkeyAy,
        uint64 encryptedAmount,
        uint64 signatureS, uint64 signatureR8x, uint64 signatureR8y
    ) public {
        // Create PublicKey struct
        PublicKey memory pubkey = PublicKey({
            Ax: pubkeyAx,
            Ay: pubkeyAy
        });

        // Create Signature struct
        Signature memory signature = Signature({
            S: signatureS,
            R8x: signatureR8x,
            R8y: signatureR8y
        });

        // Create Order struct and assign it to the mapping
        sellers[sellerAddress] = Order({
            sellerPubkey: pubkey,
            encryptedAmount: encryptedAmount,
            amountSignedBySeller: signature
        });
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
    function sendOrderInfoViaCCIP(
        uint64 destinationChainSelector,
        address receiver,
        PublicKey memory sellerPubkey,
        uint64 encryptedAmount,
        Signature memory amountSignedBySeller
    ) 
        external
        onlyOwner
        onlyWhitelistedChain(destinationChainSelector)
        returns (bytes32 messageId) 
    {
        // Encode the order information
        bytes memory encodedOrderInfo = abi.encode(
            sellerPubkey,
            encryptedAmount,
            amountSignedBySeller
        );

        // Prepare the CCIP message
        Client.EVM2AnyMessage memory ccipMessage = Client.EVM2AnyMessage({
            receiver: abi.encode(receiver),
            data: encodedOrderInfo,
            tokenAmounts: new Client.EVMTokenAmount[](0), // No token transfer
            extraArgs: Client._argsToBytes(
                Client.EVMExtraArgsV1({gasLimit: 0})
            ),
            feeToken: address(linkToken)
        });
        
        // Calculate and verify the CCIP fees
        uint256 ccipFees = router.getFee(destinationChainSelector, ccipMessage);
        if (ccipFees > linkToken.balanceOf(address(this))) {
            revert NotEnoughBalance(linkToken.balanceOf(address(this)), ccipFees);
        }

        // Approve and process the CCIP fee payment
        linkToken.approve(address(router), ccipFees);
        
        // Initiate the CCIP order information transfer
        messageId = router.ccipSend(destinationChainSelector, ccipMessage); 
        
        // Emit an event to log the order info sending details
        emit OrderInfoSent(
            messageId,
            destinationChainSelector,
            receiver,
            sellerPubkey,
            encryptedAmount,
            amountSignedBySeller,
            ccipFees
        );
    }

    function _ccipReceive(
        Client.Any2EVMMessage memory any2EvmMessage
    ) internal override{
        
        //
    }
}