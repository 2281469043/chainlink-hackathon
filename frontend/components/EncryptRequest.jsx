import TextInput from './TextInput';
import { useState, useEffect } from 'react';
import { Card, BuyerCardTitle, CardBody } from "./Card";
import Button from "./Button";
import { useAccount, useContractWrite, usePrepareContractWrite, useSwitchNetwork, useNetwork } from 'wagmi';
import BuyerABI from "../contracts/BuyerABI.json";

async function encrypt(publicKey, message) {
  const response = await fetch(`/api/encrypt?publicKey=${publicKey}&message=${message}`);
  const data = await response.json();
  return data;
}

const EncryptRequest = () => {
  const [publicKey, setPublicKey] = useState('');
  const [request, setRequest] = useState('');
  const [encryptedMessage, setEncryptedMessage] = useState('');

  useEffect(() => {
    (async () => {
      if (publicKey && request) {
        const data = await encrypt(publicKey, request);
        setEncryptedMessage(JSON.stringify(data));
      }
    })()
  }, [publicKey, request]);

  const { config: requestSupplyProofConfig, error: requestSupplyProofError } = usePrepareContractWrite({
    address: process.env.NEXT_PUBLIC_BUYER_CONTRACT_ADDRESS,
    // chainId: ,
    abi: BuyerABI.abi,
    functionName: 'requestSupplyProof',
    gas: 500_000n,
    args: [
      process.env.NEXT_PUBLIC_SELLER_CONTRACT_ADDRESS,
      process.env.NEXT_PUBLIC_ETH_CHAIN_ID,
      Uint8Array.from(request),
    ],
  })

  const { write: requestSupplyProof } = useContractWrite(requestSupplyProofConfig)

  return (
    <Card>
      <BuyerCardTitle bgColor="red-200">4. Encrypt & Send Request</BuyerCardTitle>
      <CardBody>
        <TextInput label="Seller's Ethereum Public Key" value={publicKey} onChange={setPublicKey} />
        <TextInput label="Signed Amount" value={request} onChange={setRequest} />
        <TextInput label="Encrypted Request" value={encryptedMessage} disabled />
        <Button onClick={() => requestSupplyProof?.()}> 
          Send Request
        </Button>
      </CardBody>
    </Card>
  );
}

export default EncryptRequest
