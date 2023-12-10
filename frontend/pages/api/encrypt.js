import EthCrypto from 'eth-crypto';

export default function handler(req, res) {
    const publicKey = new Uint8Array(
        Buffer.from(req.query.publicKey, 'hex')
    );
    const message = req.query.message;

    (async() => {
        const encrypted = await EthCrypto.encryptWithPublicKey(
            publicKey, 
            message
        );

        res.status(200).json(encrypted);
    })();
}