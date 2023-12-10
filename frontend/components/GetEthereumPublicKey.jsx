"use client";

import TextInput from './TextInput';
import { useState } from 'react';
import Card from './Card';
import CardTitle from './CardTitle';
import { useAccount } from 'wagmi';
import Button from './Button';

export default function GetEthereumPublicKey() {
    const [publicKey, setPublicKey] = useState('');
    const { address } = useAccount();

    return (
        <Card>
            <CardTitle>Get Ethereum Public Key</CardTitle>
            <Button onClick={async () => {
                window.ethereum.request({
                    method: "eth_getEncryptionPublicKey",
                    params: [address]
                }).then(setPublicKey);
            }}>Get Key</Button>
            <TextInput label="Ethereum Public Key" value={publicKey} onChange={setPublicKey} disabled />
        </Card>
    );
}