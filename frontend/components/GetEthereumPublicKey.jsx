"use client";

import TextInput from './TextInput';
import { useState } from 'react';
import {Card, SellerCardTitle, CardBody } from './Card';
import { useAccount } from 'wagmi';
import Button from './Button';

export default function GetEthereumPublicKey() {
    const [publicKey, setPublicKey] = useState('');
    const { address } = useAccount();

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
                <Button>
                    Share Key
                </Button>
            </CardBody>
        </Card>
    );
}
