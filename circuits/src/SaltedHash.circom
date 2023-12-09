pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/mimcsponge.circom";

template SaltedHash(length) {
    signal input ins[length];
    signal input salt;
    signal output out;

    component hasher = MiMCSponge(length + 1, 220, 1);

    hasher.k <== 0;

    for (var i = 0; i < length; i++) {
        hasher.ins[i] <== ins[i];
    }

    hasher.ins[length] <== salt;

    out <== hasher.outs[0];
}