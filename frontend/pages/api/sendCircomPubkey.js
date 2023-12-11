import path from "path";
import Web3 from "web3";
import BuyerABI from "../../contracts/Buyer.json"

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

export default async (req, res) => {
  console.log('sending cirocm key')
  const Ax = req.query.Ax;
  const Ay = req.query.Ay;

  console.log(typeof(Ax))
  res.status(200).send({'message': 'huh!'});

  const web3 = new Web3(process.env.BSC_RPC_URL);
  // console.log(BuyerABI.abi)
  // const buyerContract = new web3.eth.Contract(
  //   BuyerABI.abi,
  //   process.env.BUYER_CONTRACT_ADDRESS
  // )

  // (async () => {

  // const setKeyResponse = await buyerContract.setCircomPubkey({
  //   Ax: web3.eth.abi.encodeParameter('uint256', Ax),
  //   Ay: web3.eth.abi.encodeParameter('uint256', Ay),
  // }).call()

  // const sendKeyResponse = await buyerContract.sendCircomPubkey().call()

  // res.status(200).send("Huh!!")
  // })()

}
