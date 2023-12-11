import { Card, BuyerCardTitle, CardBody } from "./Card";
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
      <BuyerCardTitle bgColor="red-200">8. Verify Proof</BuyerCardTitle>
      <CardBody>
        <TextInput label="Proof" value={proof} onChange={setProof} />
        <Button onClick={onClick}>Send Proof</Button>
      </CardBody>
    </Card>
  );
}

export default VerifyProof;
