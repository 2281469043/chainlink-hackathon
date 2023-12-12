import { Card, BuyerCardTitle, CardBody } from "./Card";
import TextInput from "./TextInput";
import { useState, useEffect } from "react";
import Button from './Button';
import { buildEddsa } from "circomlibjs";
import BuyerABI from "../contracts/BuyerABI.json";
import { useAccount, useContractWrite, usePrepareContractWrite, useSwitchNetwork, useNetwork } from 'wagmi';

const VerifyProof = () => {
  const [proof, setProof] = useState('');

  const { config: verifyProofConfig, error: verifyProofError } = usePrepareContractWrite({
    address: process.env.NEXT_PUBLIC_BUYER_CONTRACT_ADDRESS,
    abi: BuyerABI.abi,
    functionName: 'verifyProof',
    gas: 500_000n,
    args: [
      proof,
    ],
  })

  const { write: verifyProof } = useContractWrite(verifyProofConfig)

  return (
    <Card>
      <BuyerCardTitle bgColor="red-200">8. Verify Proof</BuyerCardTitle>
      <CardBody>
        <TextInput label="Proof" value={proof} onChange={setProof} />
        <Button onClick={() => verifyProof?.()}>Verify Proof</Button>
      </CardBody>
    </Card>
  );
}

export default VerifyProof;
