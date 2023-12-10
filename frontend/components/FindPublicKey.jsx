"use client";

import TextInput from './TextInput';
import { useState } from 'react';
import Card from './Card';
import CardTitle from './CardTitle';
import { useAccount } from 'wagmi';
import Button from './Button';

export default function FindPublicKey() {
    const [publicKey, setPublicKey] = useState('');
    const { address } = useAccount();

    return (
        <Card>
            <CardTitle>Find Public Key</CardTitle>
            <Button onClick={async () => {
                window.ethereum.request({
                    method: "eth_getEncryptionPublicKey",
                    params: [address]
                }).then(setPublicKey);
            }}>Find</Button>
            <TextInput label="Public Key" value={publicKey} onChange={setPublicKey} disabled />
        </Card>
    );
}