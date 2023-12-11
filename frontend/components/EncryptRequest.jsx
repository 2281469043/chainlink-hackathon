"use client";

import TextInput from './TextInput';
import { useState, useEffect } from 'react';
import {Card, BuyerCardTitle, CardBody } from "./Card";

async function encrypt(publicKey, message) {
    const response = await fetch(`/api/encrypt?publicKey=${publicKey}&message=${message}`);
    const data = await response.json();
    return data;
}

const EncryptRequest = () => {
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
            <BuyerCardTitle bgColor="red-200">4. Encrypt & Send Request</BuyerCardTitle>
            <CardBody>
                <TextInput label="Seller's Ethereum Public Key" value={publicKey} onChange={setPublicKey} />
                <TextInput label="Signed Amount" value={request} onChange={setRequest} />
                <TextInput label="Encrypted Request" value={encryptedMessage} disabled />
            </CardBody>
        </Card>
    );
}

export default EncryptRequest
