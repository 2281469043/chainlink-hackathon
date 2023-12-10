import EthCrypto from 'eth-crypto';

export default function handler(req, res) {
    const publicKey = new Uint8Array(
        req.query.publicKey.split(',').map(parseInt)
    );
    const message = req.query.message;

    const encrypted = EthCrypto.encryptWithPublicKey(
        publicKey, 
        message
    );

    res.status(200).json(encrypted);
}