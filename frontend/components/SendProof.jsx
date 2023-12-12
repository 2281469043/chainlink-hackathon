import { Card, CardBody, SellerCardTitle } from "./Card";
import { useState, useEffect } from "react";
import Button from './Button';
import { buildEddsa } from "circomlibjs";
import TextInput from "./TextInput";
import { useAccount, useContractWrite, usePrepareContractWrite, useSwitchNetwork, useNetwork } from 'wagmi';
import SellerABI from "../contracts/SellerABI.json";

const SendProof = () => {
  const [proof, setProof] = useState('');

  const { config: provideSupplyProofConfig, error: provideSupplyProofError } = usePrepareContractWrite({
    address: process.env.NEXT_PUBLIC_SELLER_CONTRACT_ADDRESS,
    // chainId: ,
    abi: SellerABI.abi,
    functionName: 'provideSupplyProof',
    // gas: 500_000n,
    args: [
      process.env.NEXT_PUBLIC_BUYER_CONTRACT_ADDRESS,
      process.env.NEXT_PUBLIC_BSC_CHAIN_ID,
      proof
    ],
  })

  const { write: provideSupplyProof } = useContractWrite(provideSupplyProofConfig)

  return (
    <Card>
      <SellerCardTitle bgColor="red-200">7. Send Proof</SellerCardTitle>
      <CardBody>
        <TextInput label="Proof" value={proof} onChange={setProof} />
        <Button onClick={()=>provideSupplyProof?.()}>Send Proof</Button>
      </CardBody>
    </Card>
  );
}

export default SendProof;
