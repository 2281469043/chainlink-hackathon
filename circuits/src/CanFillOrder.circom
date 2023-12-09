pragma circom 2.0.0;

include "./SaltedHash.circom";
include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/gates.circom";
include "../node_modules/circomlib/circuits/eddsamimcsponge.circom";

template CanFillOrder() {
    signal input requestedSupply;
    signal input buyerPublicKeyAx;
    signal input buyerPublicKeyAy;
    signal input signatureR8x;
    signal input signatureR8y;
    signal input signatureS;
    signal input supplyHash;
    signal input supply;
    signal input salt;

    // verify signature
    component verifySignature = EdDSAMiMCSpongeVerifier();
    verifySignature.enabled <== 1;
    verifySignature.Ax <== buyerPublicKeyAx;
    verifySignature.Ay <== buyerPublicKeyAy;
    verifySignature.M <== supplyHash;
    verifySignature.R8x <== signatureR8x;
    verifySignature.R8y <== signatureR8y;
    verifySignature.S <== signatureS;
    verifySignature.M = requestedSupply;
    
    // verify supply hash
    component calculatedHash = SaltedHash(1);
    calculatedHash.salt <== salt;
    calculatedHash.ins[0] <== supply;
    calculatedHash.out === suppliesHash;

    // verify amount
    component checkSupplies = LessEqThan(64);
    checkSupplies.in[0] = requestedSupply;
    checkSupplies.in[1] = supply;
    checkSupplies.out === 1;
}

component main{public [supplyHash, buyerPublicKey]} = CanFillOrder();
