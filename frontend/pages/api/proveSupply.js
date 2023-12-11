import path from "path";
import * as snarkjs from "snarkjs";
const { buildEddsa } = require("circomlibjs");
import Web3 from "web3";

async function calculateSupplyHash(supply, salt) {
  const { publicSignals } = await snarkjs.groth16.fullProve(
    { ins: supply, salt: salt },
    path.join(process.cwd(), "public", "SaltedHashMain.wasm"),
    path.join(process.cwd(), "public", "SaltedHashMain_0001.zkey")
  );

  return publicSignals[0];
}

async function proveSupply(inputSignals) {
  const { proof, publicSignals } = await snarkjs.groth16.fullProve(
    inputSignals,
    path.join(process.cwd(), "public", "CanFillOrder.wasm"),
    path.join(process.cwd(), "public", "CanFillOrder_0001.zkey")
  );

  return {
    proof: proof,
    publicSignals: publicSignals
  };
}

function arrayToField(eddsa, array) {
  const F = eddsa.babyJub.F;
  return F.toString(F.e(Uint8Array.from(array)));
}

export default async (req, res) => {
  const inputSignalsEncoded = req.query.inputSignals;
  let inputSignals = JSON.parse(Buffer.from(inputSignalsEncoded, "base64").toString("utf-8"));

  const eddsa = await buildEddsa();
  inputSignals.buyerPublicKeyAx = arrayToField(eddsa, inputSignals.buyerPublicKeyAx);
  inputSignals.buyerPublicKeyAy = arrayToField(eddsa, inputSignals.buyerPublicKeyAy);
  inputSignals.signatureR8x = arrayToField(eddsa, inputSignals.signatureR8x);
  inputSignals.signatureR8y = arrayToField(eddsa, inputSignals.signatureR8y);

  const supplyHash = await calculateSupplyHash(inputSignals.supply, inputSignals.salt);
  const proof = await proveSupply({
    ...inputSignals,
    supplyHash: supplyHash
  });

  const calldata = await snarkjs.groth16.exportSolidityCallData(proof.proof, proof.publicSignals);

  const parsedCalldata = JSON.parse('[' + calldata + ']');

  const web3 = new Web3();
  const calldataHex = web3.eth.abi.encodeFunctionCall(
    { "type": "function", "name": "verifyProof", "inputs": [{ "name": "_pA", "type": "uint256[2]", "internalType": "uint256[2]" }, { "name": "_pB", "type": "uint256[2][2]", "internalType": "uint256[2][2]" }, { "name": "_pC", "type": "uint256[2]", "internalType": "uint256[2]" }, { "name": "_pubSignals", "type": "uint256[3]", "internalType": "uint256[3]" }], "outputs": [{ "name": "", "type": "bool", "internalType": "bool" }], "stateMutability": "view" }
    , parsedCalldata);

  res.status(200).send(calldataHex);

}
