"use client";

import TextInput from './TextInput';
import { useState } from 'react';
import {Card, CardTitle, CardBody } from './Card';
import { useAccount } from 'wagmi';
import Button from './Button';

export default function GetEthereumPublicKey() {
    const [publicKey, setPublicKey] = useState('');
    const { address } = useAccount();

    return (
        <Card>
            <CardTitle bgColor="blue-400">2. Buyer: Get And Share Ethereum Public Key</CardTitle>
            <CardBody>
                <Button onClick={async () => {
                    window.ethereum.request({
                        method: "eth_getEncryptionPublicKey",
                        params: [address]
                    }).then(setPublicKey);
                }}>Get Key</Button>
                <TextInput label="Ethereum Public Key" value={publicKey} onChange={setPublicKey} disabled />
                <Button>
                    Share Key
                </Button>
            </CardBody>
        </Card>
    );
}