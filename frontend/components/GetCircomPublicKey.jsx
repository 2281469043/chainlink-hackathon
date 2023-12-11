import { Card, BuyerCardTitle, CardBody } from "./Card";
import TextInput from "./TextInput";
import { useState, useEffect } from "react";
import { buildEddsa } from "circomlibjs";
import Button from "./Button";

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
      <BuyerCardTitle>1. Get & Share Circom Public Key</BuyerCardTitle>
      <CardBody>
        <TextInput label="Circuit Private Key" value={privateKey} onChange={setPrivateKey} />
        <TextInput label="Public Key X" value={Ax} disabled />
        <TextInput label="Public Key Y" value={Ay} disabled />
        <Button onClick={async () => {
          alert(Ax)
          const response = await fetch(`/api/sendCircomPubkey?Ax=${Ax}&Ay=${Ay}`);
          alert(JSON.stringify(response))
        }}>Share Circom Key</Button>
      </CardBody>
    </Card>
  );
}
