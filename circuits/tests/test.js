const { expect } = require("chai");
const path = require("path");
const wasm_tester = require("circom_tester").wasm;
const { buildEddsa } = require("circomlibjs");
const { Scalar } = require("ffjavascript");

async function calculateSupplyHash(supply, salt) {
  const circuitPath = path.join(__dirname, "..", "src", "SaltedHashMain.circom");

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

async function calculateSignature(prv, msg) {
  const eddsa = await buildEddsa();
  const msgF = eddsa.babyJub.F.e(msg)
  const signature = eddsa.signMiMCSponge(prv, msgF);
  return signature;
}

async function verifySignature(A, msg, signature) {
  const eddsa = await buildEddsa();
  const msgF = eddsa.babyJub.F.e(msg)
  return eddsa.verifyMiMCSponge(msgF, signature, A);
}

async function getPublicKey(prv) {
  const eddsa = await buildEddsa();
  return eddsa.prv2pub(prv);
}

async function toBabyJubScalar(value) {
  const eddsa = await buildEddsa();
  const F = eddsa.babyJub.F;
  return F.toString(F.e(value));
}

describe("SaltedHash", function() {
  it("Should calculate a hash", async function() {
    const hash = await calculateSupplyHash(0, 0);

    expect(hash).to.not.be.undefined;
    expect(hash).to.not.equal(0);
  });
});

const PRIVATE_KEY_HEX = "1".repeat(64);
const PRIVATE_KEY_BUFFER = Buffer.from(PRIVATE_KEY_HEX, "hex");

const toHexString = bytes =>
  bytes.reduce((str, byte) => str + byte.toString(16).padStart(2, '0'), '');

describe("Signature", function() {
  this.timeout(10_000);

  it("Should calculate a public key", async function() {
    const [Ax, Ay] = await getPublicKey(PRIVATE_KEY_BUFFER);

    expect(Ax).to.not.be.undefined;
    expect(Ax).to.not.equal(0);
    expect(Ay).to.not.be.undefined;
    expect(Ay).to.not.equal(0);
  });

  it("Should sign and verify a message", async function() {
    const msg = "10";

    const signature = await calculateSignature(PRIVATE_KEY_BUFFER, msg);

    const { R8, S } = signature;
    const [R8x, R8y] = R8;

    expect(R8x).to.not.be.undefined;
    expect(R8x).to.not.equal(0);
    expect(R8y).to.not.be.undefined;
    expect(R8y).to.not.equal(0);
    expect(S).to.not.be.undefined;
    expect(S).to.not.equal(0);

    const [Ax, Ay] = await getPublicKey(PRIVATE_KEY_BUFFER);

    const verified = await verifySignature([Ax, Ay], msg, signature);
    expect(verified).to.be.true;
  });
});


describe('CanFillOrder', function() {
  this.timeout(10_000);

  const circuitPath = path.join(__dirname, "..", "src", "CanFillOrder.circom");

  it('Should succeed with valid inputs', async function() {
    const circuit = await wasm_tester(
      circuitPath
    );

    const [Ax, Ay] = await getPublicKey(PRIVATE_KEY_BUFFER);
    const msg = 10;
    const { R8, S } = await calculateSignature(PRIVATE_KEY_BUFFER, msg);

    const [R8x, R8y] = R8;

    const ffR8x = await toBabyJubScalar(R8x);
    const ffR8y = await toBabyJubScalar(R8y);
    const ffAx = await toBabyJubScalar(Ax);
    const ffAy = await toBabyJubScalar(Ay);

    const w = await circuit.calculateWitness({
      requestedSupply: msg,
      buyerPublicKeyAx: ffAx,
      buyerPublicKeyAy: ffAy,
      signatureR8x: ffR8x,
      signatureR8y: ffR8y,
      signatureS: S,
      supply: 100,
      supplyHash: await calculateSupplyHash(100, 0),
      salt: 0
    });

    await circuit.checkConstraints(w);
  });
});
