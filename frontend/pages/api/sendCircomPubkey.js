import path from "path";
import Web3 from "web3";
import BuyerABI from "../../contracts/Buyer.json"

async function proveSupply(inputSignals) {
  const {proof, publicSignals} = await snarkjs.groth16.fullProve(
    inputSignals,
    path.join(process.cwd(), "public", "CanFillOrder.wasm"),
    path.join(process.cwd(), "public", "CanFillOrder_0001.zkey")
  );

  return {
    proof: proof,
    publicSignals: publicSignals
  };
}

export default async function handler(req, res) {
  console.log('buyerABI')
  console.log(JSON.stringify(BuyerABI['abi']))
  const Ax = req.query.Ax;
  const Ay = req.query.Ay;
  
  const web3 = new Web3('https://bsc-dataseed1.binance.org:443');
  const buyerContract = web3.eth.Contract(
    BuyerABI.abi,
    process.env.BUYER_CONTRACT_ADDRESS
  )
  
  const setKeyResponse = await buyerContract.setCircomPubkey({
    Ax: web3.eth.abi.encodeParameter('uint256',Ax),
    Ay: web3.eth.abi.encodeParameter('uint256',Ay),
  }).call()
  
  const sendKeyResponse = await buyerContract.sendCircomPubkey().call()
  
  res.status(200).send(sendKeyResponse)

  // console.log(JSON.stringify(response))
  


  // (async () => {
  //   const eddsa = await buildEddsa();
  //   inputSignals.buyerPublicKeyAx = arrayToField(eddsa, inputSignals.buyerPublicKeyAx);
  //   inputSignals.buyerPublicKeyAy = arrayToField(eddsa, inputSignals.buyerPublicKeyAy);
  //   inputSignals.signatureR8x = arrayToField(eddsa, inputSignals.signatureR8x);
  //   inputSignals.signatureR8y = arrayToField(eddsa, inputSignals.signatureR8y);

  //   const supplyHash = await calculateSupplyHash(inputSignals.supply, inputSignals.salt);
  //   const proof = await proveSupply({
  //     ...inputSignals,
  //     supplyHash: supplyHash
  //   });

  //   const calldata = await snarkjs.groth16.exportSolidityCallData(proof.proof, proof.publicSignals);

  //   const parsedCalldata = JSON.parse('['+calldata+']');

  //   const web3 = new Web3();
  //   const calldataHex = web3.eth.abi.encodeFunctionCall(
  //     {"type":"function","name":"verifyProof","inputs":[{"name":"_pA","type":"uint256[2]","internalType":"uint256[2]"},{"name":"_pB","type":"uint256[2][2]","internalType":"uint256[2][2]"},{"name":"_pC","type":"uint256[2]","internalType":"uint256[2]"},{"name":"_pubSignals","type":"uint256[3]","internalType":"uint256[3]"}],"outputs":[{"name":"","type":"bool","internalType":"bool"}],"stateMutability":"view"}
  //   , parsedCalldata);

  //   res.status(200).send(calldataHex);

  // })();
}