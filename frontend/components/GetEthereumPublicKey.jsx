import TextInput from './TextInput';
import { useState } from 'react';
import { Card, SellerCardTitle, CardBody } from './Card';
import Button from './Button';
import { useAccount, useContractWrite, usePrepareContractWrite, useSwitchNetwork, useNetwork } from 'wagmi';
import SellerABI from "../contracts/SellerABI.json";

export default function GetEthereumPublicKey() {
  const [publicKey, setPublicKey] = useState('');
  const { address } = useAccount();

  const { config: provideEthPubkeyConfig, error: provideEthPubkeyError } = usePrepareContractWrite({
    address: process.env.NEXT_PUBLIC_SELLER_CONTRACT_ADDRESS,
    // chainId: ,
    abi: SellerABI.abi,
    functionName: 'provideEthPubkey',
    // gas: 500_000n,
    args: [
      process.env.NEXT_PUBLIC_BUYER_CONTRACT_ADDRESS,
      process.env.NEXT_PUBLIC_BSC_CHAIN_ID
    ],
  })

  const { write: provideEthPubkey } = useContractWrite(provideEthPubkeyConfig)

  return (
    <Card>
      <SellerCardTitle bgColor="blue-200">2. Get & Share Ethereum Public Key</SellerCardTitle>
      <CardBody>
        <Button onClick={async () => {
          window.ethereum.request({
            method: "eth_getEncryptionPublicKey",
            params: [address]
          }).then(setPublicKey);
        }}>Get Key</Button>
        <TextInput label="Ethereum Public Key" value={publicKey} onChange={setPublicKey} disabled />
        <Button onClick={() => provideEthPubkey?.()}>
          Share Key
        </Button>
      </CardBody>
    </Card>
  );
}
