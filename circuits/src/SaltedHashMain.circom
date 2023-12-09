pragma circom 2.0.0;

include "./SaltedHash.circom";

// just export SaltedHash for a single value as a main component
component main = SaltedHash(1);