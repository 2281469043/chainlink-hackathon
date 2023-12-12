# Chainlink Hackathon Project

```mermaid
sequenceDiagram
   actor B as Buyer
   participant BC as Buyer's Smart Contract (Binance Chain)
   participant CCIP as Cross-Chain Interoperability Protocol (CCIP)
   participant SC as Seller's Smart Contract (Sepolia Chain)
   actor S as Seller
  
   B->>+B: Determine stock amount required
   B->>+B: Sign and encrypt amount
   B->>+BC: Send encrypted amount and signature
   BC->>+CCIP: Message to seller's contract
   CCIP->>+SC: Relay buyer's message
   SC->>+S: Decrypt amount and signature
   S->>+S: Verify buyer's message authenticity
   S->>+S: Generate zero-knowledge proof
   S->>+SC: Send proof to smart contract
   SC->>+CCIP: Relay proof
   CCIP->>+BC: Send seller's proof
   BC->>+B: Verify zero-knowledge proof
   B->>S: Trade upon proof verification
```

## Usage

### Build Circuits

Make sure [Circom](https://docs.circom.io/getting-started/installation) is installed.

```bash
cd circuits
npm install
./build.sh
```

### Run Frontend

First make a file called `.env.local` in the `frontend` directory with the following contents (replacing `<YOUR WALLETCONNECT PROJECT ID>` with your WalletConnect project ID):

```
NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID="<YOUR WALLETCONNECT PROJECT ID>"
```

Then you can run the frontend:

```bash
cd frontend
npm install
npm run dev
```

## Development

### Run Tests

```bash
cd circuits
npm run test
```
