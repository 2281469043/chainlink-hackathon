import { Card, BuyerCardTitle, CardBody } from "./Card";
import TextInput from "./TextInput";
import { useState, useEffect } from "react";
import { buildEddsa } from "circomlibjs";
import Button from "./Button";
import { useAccount, useContractWrite, usePrepareContractWrite, useSwitchNetwork, useNetwork } from 'wagmi';
import BuyerABI from "../contracts/BuyerABI.json";
import { bscTestnet } from 'wagmi/chains'

export default function SignAmount() {
  const [privateKey, setPrivateKey] = useState('');
  const [publicKey, setPublicKey] = useState(null);
  const [eddsa, setEddsa] = useState(null);
  const [buyerABI, setBuyerABI] = useState({});

  useEffect(() => {
    (async () => {
      if (!eddsa) {
        const eddsa = await buildEddsa();
        setEddsa(eddsa);
      }
    })()
  }, [eddsa]);

  useEffect(() => {
    (async () => {
      if (eddsa && privateKey.length !== 0) {
        const publicKey = eddsa.prv2pub(privateKey);
        setPublicKey(publicKey);
      }
    })()
  }, [eddsa, privateKey]);

  const Ax = publicKey ? Buffer.from(publicKey[0]).toString('hex') : '';
  const Ay = publicKey ? Buffer.from(publicKey[1]).toString('hex') : '';

  // const { address } = useAccount();
  // const web3 = new Web3(process.env.NEXT_PUBLIC_BSC_RPC_URL); 
  // const { chain } = useNetwork()
  const { chains, error, isLoading, pendingChainId, switchNetwork } = useSwitchNetwork()

  const { config: setCircomPubkeyConfig, error: setCircomPubkeyError } = usePrepareContractWrite({
    address: process.env.NEXT_PUBLIC_BUYER_CONTRACT_ADDRESS,
    // chainId: ,
    abi: BuyerABI.abi,
    functionName: 'setCircomPubkey',
    args: ['0x' + Ax, '0x' + Ay],
  })

  const { write: setCircomPubkey } = useContractWrite(setCircomPubkeyConfig)

  const { config: provideCircomPubkeyConfig, error: provideCircomPubkeyError } = usePrepareContractWrite({
    address: process.env.NEXT_PUBLIC_BUYER_CONTRACT_ADDRESS,
    // chainId: ,
    abi: BuyerABI.abi,
    functionName: 'provideCircomPubkey',
    gas: 500_000n,
    args: [
      process.env.NEXT_PUBLIC_SELLER_CONTRACT_ADDRESS,
      process.env.NEXT_PUBLIC_ETH_CHAIN_ID
    ],
  })

  const { write: provideCircomPubkey } = useContractWrite(provideCircomPubkeyConfig)

  return (
    <Card>
      <BuyerCardTitle>1. Get & Share Circom Public Key</BuyerCardTitle>
      <CardBody>
        <TextInput label="Circuit Private Key" value={privateKey} onChange={setPrivateKey} />
        <TextInput label="Public Key X" value={Ax} disabled />
        <TextInput label="Public Key Y" value={Ay} disabled />
        <div className="grid grid-cols-2 gap-2">
        <Button onClick={() => {
          setCircomPubkey?.()
        }
        }>Set Circom Key</Button>
        <Button onClick={() => {
          provideCircomPubkey?.()
        }
        }>Share Circom Key</Button>
        </div>

      </CardBody>
    </Card>
  );
}
