"use client";

import TextInput from './TextInput';
import { useState, useEffect } from 'react';
import Card from './Card';
import CardTitle from './CardTitle';

async function encrypt(publicKey, message) {
    const response = await fetch(`/api/encrypt?publicKey=${publicKey}&message=${message}`);
    const data = await response.json();
    return data;
}

export default function EncryptRequest() {
    const [publicKey, setPublicKey] = useState('');
    const [amount, setAmount] = useState('');
    const [encryptedMessage, setEncryptedMessage] = useState('');

    useEffect(() => {
        (async () => {
            if (publicKey && message) {
                const data = await encrypt(publicKey, amount);
                setEncryptedMessage(JSON.stringify(data));
            }
        })()
    }, [publicKey, amount]);

    return (
        <Card>
            <CardTitle>Encrypt Request</CardTitle>
            <TextInput label="Public Key" value={publicKey} onChange={setPublicKey} />
            <TextInput label="Requested Amount" value={amount} onChange={setAmount} />
            <TextInput label="Encrypted Message" value={encryptedMessage} disabled />
        </Card>
    );
}