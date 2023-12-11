import {Card, CardBody, CardTitle} from "./Card";
import { useState, useEffect } from "react";
import Button from './Button';
import { buildEddsa } from "circomlibjs";
import TextInput from "./TextInput";

const SendProof = () => {
    const [proof, setProof] = useState('');
    const [publicKey, setPublicKey] = useState(null);
    const [eddsa, setEddsa] = useState(null);
    
    const sendProof = () => {
        // TODO: send proof to contract
        
        
    }
    
    return (
        <Card>
            <CardTitle>Sign Amount</CardTitle>
            <CardBody>
                <TextInput label="Proof" value={amount} onChange={setAmount} />
                <Button onClick={sendProof}>Send Proof</Button>
            </CardBody>
        </Card>
    );
}

export default SendProof;