import { Card, CardBody, SellerCardTitle } from "./Card";
import { useState, useEffect } from "react";
import Button from './Button';
import { buildEddsa } from "circomlibjs";
import TextInput from "./TextInput";

const SendProof = () => {
  const [proof, setProof] = useState('');

  const sendProof = () => {
    // TODO: send proof to contract


  }

  return (
    <Card>
      <SellerCardTitle bgColor="red-200">7. Send Proof</SellerCardTitle>
      <CardBody>
        <TextInput label="Proof" value={proof} onChange={setProof} />
        <Button onClick={sendProof}>Send Proof</Button>
      </CardBody>
    </Card>
  );
}

export default SendProof;
