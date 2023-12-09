pragma circom 2.0.0;

include "./SaltedHash.circom";
include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/gates.circom";

template CanFillOrder() {
    signal input requestedSupply;
    signal input supplyHash;
    signal input supply;
    signal input salt;

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

component main{public [supplyHash]} = CanFillOrder();
