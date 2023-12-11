"use client";

import TextInput from './TextInput';
import { useState } from 'react';
import { Card, CardBody, SellerCardTitle } from "./Card";
import Button from './Button';

function flipEndian(hexString) {
  const result = [];
  for (let i = 0; i < hexString.length; i += 2) {
    result.unshift(hexString.substr(i, 2));
  }
  return result.join('');
}

function hexToUint8(hexString) {
  // alert(hexString)
  const uint8Array = Uint8Array.from(Buffer.from(hexString, 'hex'));
  let result = [];
  for (let i = 0; i < uint8Array.length; i++) {
    result.push(uint8Array[i]);
  }
  return result;
}

export default function ProveSupply() {
  const [Ax, setAx] = useState('');
  const [Ay, setAy] = useState('');
  const [signedAmount, setSignedAmount] = useState('');
  const [supply, setSupply] = useState('');
  const [salt, setSalt] = useState('');
  const [proof, setProof] = useState('');

  return (
    <Card>
      <SellerCardTitle bgColor="blue-200">6. Generate Proof</SellerCardTitle>
      <CardBody>
        <div className="grid grid-cols-2 gap-2">
          <TextInput label="Public Key X" value={Ax} onChange={setAx} />
          <TextInput label="Public Key Y" value={Ay} onChange={setAy} />
          <TextInput label="Signed Amount" value={signedAmount} onChange={setSignedAmount} />
          <TextInput label="Supply" value={supply} onChange={setSupply} />
          <TextInput label="Salt" value={salt} onChange={setSalt} />
        </div>
        <Button onClick={async () => {
          const signedAmountObj = JSON.parse(signedAmount);
          // alert(JSON.stringify(signedAmountObj))
          // console.log(signedAmountObj)

          const inputSignals = {
            requestedSupply: signedAmountObj.amount,
            signatureR8x: hexToUint8(signedAmountObj.R8x),
            signatureR8y: hexToUint8(signedAmountObj.R8y),
            signatureS: signedAmountObj.S,
            buyerPublicKeyAx: hexToUint8(Ax),
            buyerPublicKeyAy: hexToUint8(Ay),
            supply: supply,
            salt: salt,
          };

          const inputSignalsString = JSON.stringify(inputSignals);
          const inputSignalsEncoded = Buffer.from(inputSignalsString).toString('base64');

          const response = await fetch(
            `/api/proveSupply?inputSignals=${inputSignalsEncoded}`,
          );
          const text = await response.text();
          setProof(text);
        }}>Prove</Button>
        <TextInput label="Proof" value={proof} onChange={setProof} disabled />
      </CardBody>
    </Card>
  );
}
