import secp256k1 from 'secp256k1';

export default function handler(req, res) {
    const signature = Buffer.from(req.query.signature, 'hex');

    if (signature.length !== 65) {
        throw new Error('Invalid signature length')
    }

    const msgHash = Buffer.from(req.query.msgHash, 'hex');
    let v = signature[64];
    if (v < 27) {
        v += 27
    }
    const signatureArray = Uint8Array.from(signature.subarray(0, 64));
    const recovery = v - 27;

    const msgArray = Uint8Array.from(msgHash);
    
    const senderPubKey = secp256k1.ecdsaRecover(signatureArray, recovery, msgArray);

    res.status(200).send(Buffer.from(senderPubKey).toString('hex'));
}