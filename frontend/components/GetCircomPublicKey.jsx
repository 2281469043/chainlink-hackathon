import Card from "./Card";
import CardTitle from "./CardTitle";
import TextInput from "./TextInput";
import { useState, useEffect } from "react";
import { buildEddsa } from "circomlibjs";

export default function SignAmount() {
    const [privateKey, setPrivateKey] = useState('');
    const [publicKey, setPublicKey] = useState(null);
    const [eddsa, setEddsa] = useState(null);

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

    return (
        <Card>
            <CardTitle>Get Circom Public Key</CardTitle>
            <TextInput label="Circuit Private Key" value={privateKey} onChange={setPrivateKey} />
            <TextInput label="Public Key X" value={Ax} disabled />
            <TextInput label="Public Key Y" value={Ay} disabled />
        </Card>
    );
}
