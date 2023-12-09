PTAU_FILE="ptau_14.ptau"

if [ ! -f "$PTAU_FILE" ]; then
  echo "Downloading $PTAU_FILE"
  wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_14.ptau -O $PTAU_FILE
fi

for CIRCUIT_NAME in CanFillOrder
do
  cd build
  circom ../src/$CIRCUIT_NAME.circom --r1cs --wasm --sym --c
  cd ..

  npx snarkjs groth16 setup build/$CIRCUIT_NAME.r1cs $PTAU_FILE build/${CIRCUIT_NAME}_0000.zkey
  echo "this should be random" | npx snarkjs zkey contribute build/${CIRCUIT_NAME}_0000.zkey build/${CIRCUIT_NAME}_0001.zkey --name="1st Contributor Name" -v
  npx snarkjs zkey verify build/${CIRCUIT_NAME}.r1cs $PTAU_FILE build/${CIRCUIT_NAME}_0001.zkey
  npx snarkjs zkey export verificationkey build/${CIRCUIT_NAME}_0001.zkey build/${CIRCUIT_NAME}_verification_key.json
  npx snarkjs zkey export solidityverifier build/${CIRCUIT_NAME}_0001.zkey build/${CIRCUIT_NAME}_verifier.sol
done