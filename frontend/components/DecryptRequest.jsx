import { useState } from "react";
import {Card, CardBody, CardTitle} from "./Card";
import TextInput from "./TextInput";
import Button from "./Button";
import { useAccount } from 'wagmi'

export default function DecryptRequest() {
    const [ciphertext, setCiphertext] = useState('');
    const [signedAmount, setSignedAmount] = useState('');
    const { address } = useAccount();

    return (
        <Card>
            <CardTitle>Decrypt Request</CardTitle>
            <CardBody>
            <TextInput label="Ciphertext" value={ciphertext} onChange={setCiphertext} />
            <Button onClick={async () => {
                let message = await window.ethereum.request({
                    "method": "eth_decrypt",
                    "params": [
                        Buffer.from(ciphertext, 'utf-8'),
                        address
                    ]
                });
                setSignedAmount(message);
            }}>Decrypt</Button>
            <TextInput label="Address" value={address} onChange={() => {}} disabled />
            <TextInput label="Signed Amount" value={signedAmount} onChange={setSignedAmount} disabled />
            </CardBody>
        </Card>
    );
}