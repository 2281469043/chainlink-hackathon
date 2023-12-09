const { expect } = require("chai");
const path = require("path");
const wasm_tester = require("circom_tester").wasm;

async function calculateSupplyHash(supply, salt) {
  const circuitPath = path.join(__dirname, "../src/SaltedHashMain.circom");

  const circuit = await wasm_tester(
    circuitPath
  );
  await circuit.loadSymbols();

  const w = await circuit.calculateWitness({
    ins: [supply],
    salt: salt
  });

  return w[circuit.symbols["main.out"].varIdx].toString();
}

describe("SaltedHash", function() {
  it("Should calculate a hash", async function() {
    const hash = await calculateSupplyHash(0, 0);
    expect(hash).to.not.be.undefined;
    expect(hash).to.not.equal(0);
  });
});

// describe('CanFillOrder', function() {
//   const circuitPath = path.join(__dirname, "canfillorder.circom");

//   it('Should succeed with valid inputs', async function() {
//     const circuit = await wasm_tester(
//       circuitPath
//     );

//     let supplies = [...SUPPLIES];
//     supplies[5] = 10;

//     const w = await circuit.calculateWitness({
//       supplies: supplies,
//       seller: 5,
//       supply: 5,
//       suppliesHash: await calculateSuppliesHash(supplies, 0),
//       salt: 0
//     });

//     await circuit.checkConstraints(w);
//   });

//   it('Should fail with invalid hash', async function() {
//     const circuit = await wasm_tester(
//       circuitPath
//     );

//     let supplies = [...SUPPLIES];
//     supplies[5] = 10;

//     let passed = false;

//     try {
//       await circuit.calculateWitness({
//         supplies: supplies,
//         seller: 5,
//         supply: 5,
//         suppliesHash: await calculateSuppliesHash(SUPPLIES, 0),
// 	salt: 0
//       });
//       passed = true;
//     } catch (e) {
//       expect(e.message).to.contain("Assert Failed.");
//     }

//     expect(passed).to.be.false;
//   });

//   it('Should fail with invalid index', async function() {
//     const circuit = await wasm_tester(
//       circuitPath
//     );

//     let passed = false;

//     try {
//       await circuit.calculateWitness({
//         supplies: SUPPLIES,
//         seller: 11,
//         supply: 0,
//         suppliesHash: await calculateSuppliesHash(SUPPLIES, 0),
// 	salt: 0
//       });
//       passed = true;
//     } catch (e) {
//       expect(e.message).to.contain("Assert Failed.");
//     }

//     expect(passed).to.be.false;
//   });

//   it('Should fail with invalid supply', async function() {
//     const circuit = await wasm_tester(
//       circuitPath
//     );

//     let passed = false;

//     try {
//       await circuit.calculateWitness({
//         supplies: SUPPLIES,
//         seller: 5,
//         supply: 1,
//         suppliesHash: await calculateSuppliesHash(SUPPLIES, 0),
// 	salt: 0
//       });
//       passed = true;
//     } catch (e) {
//       expect(e.message).to.contain("Assert Failed.");
//     }

//     expect(passed).to.be.false;
//   });
// });
