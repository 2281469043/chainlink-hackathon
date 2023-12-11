import { Card, CardTitle, CardBody } from "./Card";
import TextInput from "./TextInput";
import { useState, useEffect } from "react";
import { buildEddsa } from "circomlibjs";

export default function SignAmount() {
    const [amount, setAmount] = useState('');
    const [privateKey, setPrivateKey] = useState('');
    const [signature, setSignature] = useState(null);
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
            if (eddsa && amount && privateKey.length !== 0) {
                const msg = BigInt(amount);
                const msgF = eddsa.babyJub.F.e(msg);
                const signature = eddsa.signMiMCSponge(privateKey, msgF);

                setSignature({
                    ...signature,
                    amount: amount
                });
            }
        })()
    }, [eddsa, amount, privateKey]);

    const formattedSignature = signature ? JSON.stringify({
        R8x: Buffer.from(signature.R8[0]).toString('hex'),
        R8y: Buffer.from(signature.R8[1]).toString('hex'),
        S: signature.S.toString(10),
        amount: signature.amount
    }) : '';

    return (
        <Card>
            <CardTitle bgColor="red-400">3. Buyer: Sign Amount</CardTitle>
            <CardBody>
                <TextInput label="Amount" value={amount} onChange={setAmount} />
                <TextInput label="Circuit Private Key" value={privateKey} onChange={setPrivateKey} />
                <TextInput label="Signature" value={formattedSignature} disabled />
            </CardBody>
        </Card>
    );
}
