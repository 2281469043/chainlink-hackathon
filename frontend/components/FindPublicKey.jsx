"use client";

import TextInput from './TextInput';
import { useEffect, useState } from 'react';
import Card from './Card';
import CardTitle from './CardTitle';
import { usePublicClient } from 'wagmi';

export default function FindPublicKey() {
    const publicClient = usePublicClient();

    const [txHash, setTxHash] = useState('');
    const [transaction, setTransaction] = useState(null);
    const [signature, setSignature] = useState('');
    const [msgHash, setMsgHash] = useState('');
    const [publicKey, setPublicKey] = useState('');

    useEffect(() => {
        if (txHash && publicClient) {
            (async () => {
                let tx = await publicClient.getTransaction({ 
                    hash: txHash
                });
                setTransaction(tx);
            })()
        }
    }, [txHash, publicClient]);

    useEffect(() => {
        if (transaction) {
            let r = transaction.r.slice(2);
            let s = transaction.s.slice(2);
            let v = "0" + transaction.v.toString();
            setSignature(r + s + v);
        }
    }, [transaction]);

    useEffect(() => {
        if (transaction) {
            setMsgHash(transaction.hash.slice(2));
        }
    }, [transaction]);

    useEffect(() => {
        (async () => {
            if (signature && msgHash) {
                const response = await fetch(`/api/findPublicKey?signature=${signature}&msgHash=${msgHash}`);
                const data = await response.text();
                setPublicKey(data);
            }
        })()
    }, [signature, msgHash]);

    return (
        <Card>
            <CardTitle>Find Public Key</CardTitle>
            <TextInput label="Transaction Hash" value={txHash} onChange={setTxHash} />
            <TextInput label="Signature" value={signature} onChange={setSignature} disabled />
            <TextInput label="Message Hash" value={msgHash} onChange={setMsgHash} disabled />
            <TextInput label="Public Key" value={publicKey} onChange={setPublicKey} disabled />
        </Card>
    );
}