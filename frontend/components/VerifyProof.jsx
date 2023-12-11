import {Card, CardBody, CardTitle} from "./Card";
import TextInput from "./TextInput";
import { useState, useEffect } from "react";
import Button from './Button';
import { buildEddsa } from "circomlibjs";

const VerifyProof = () => {
    const [proof, setProof] = useState('');
    
    const onClick = () => {
        // TODO: verify proof on buyer contract
        
    }
    
    return (
        <Card>
            <CardTitle bgColor="red-400">6. Buyer: Verify Proof</CardTitle>
            <CardBody>
                <TextInput label="Proof" value={proof} onChange={setProof} />
                <Button onClick={onClick}>Send Proof</Button>
            </CardBody>
        </Card>
    );
}

export default VerifyProof;