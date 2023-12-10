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

    return (
        <Card>
            <CardTitle>Encrypt Request</CardTitle>
            <TextInput label="Public Key" value={publicKey} onChange={setPublicKey} />
            <TextInput label="Requested Amount" value={request} onChange={setRequest} />
            <TextInput label="Ciphertext" value={encryptedMessage} disabled />
        </Card>
    );
}