"use client";

import TextInput from './TextInput';
import { useState, useEffect } from 'react';
import Card from './Card';
import CardTitle from './CardTitle';

async function encrypt(publicKey, message) {
    const response = await fetch(`/api/encrypt?publicKey=${publicKey}&message=${message}`);
    const data = await response.text();
    return data;
}

export default function EncryptRequest() {
    const [publicKey, setPublicKey] = useState('');
    const [message, setMessage] = useState('');
    const [encryptedMessage, setEncryptedMessage] = useState('');

    useEffect(() => {
        (async () => {
            if (publicKey && message) {
                const data = await encrypt(publicKey, message);
                setEncryptedMessage(JSON.stringify(data));
            }
        })()
    }, [publicKey, message]);

    return (
        <Card>
            <CardTitle>Encrypt Request</CardTitle>
            <TextInput label="Public Key" value={publicKey} onChange={setPublicKey} />
            <TextInput label="Message" value={message} onChange={setMessage} />
            <TextInput label="Encrypted Message" value={encryptedMessage} disabled />
        </Card>
    );
}