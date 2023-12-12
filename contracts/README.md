# Contracts for Cross Link Private Supply
This project was built and tested using [Foundry](https://github.com/foundry-rs/foundry)

## Contracts
The main contracts are `src/Buyer.sol` and `src/Seller.sol`.
These contracts inherit from `src/TradeEntity.sol`, which inherits from `OwnerIsCreator` and `CCIPReceiver` to enable a secure cross-chain interaction.
The buyer contract initiates the interaction, to which the seller contract responds.

## To deploy
Run `yarn deploy` to deply both contracts.

## To load the contracts
Run `yarn load-buyer && yarn load-seller` to load the respective contracts with the LINK token.

## To test the contracts
Run `yarn test-buyer && yarn test-seller` to test both of the contracts.
The contents of the tests can be changed in the `script/Buyer.s.sol` and `script/Seller.s.sol` respectively.