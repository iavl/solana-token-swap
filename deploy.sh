#!/bin/bash

network=${1:-devnet}

echo "Deploying to $network"

# prepare deployer keypair
deployerKeypair=./tests/keys/deployer.json
# generate a new program id for the first time
if [ ! -f $deployerKeypair ]; then
    programKeypair=$(solana-keygen grind --starts-with TT:1 | grep 'Wrote keypair' | awk '{print $4}')
    mv $programKeypair ./tests/keys/test-program-keypair.json
fi
echo "Deployer keypair: $(solana address -k $deployerKeypair)"

# config the cluster(localhost, devnet or mainnet-beta)
# export network="https://solana-devnet.g.alchemy.com/v2/DBJZLQZIkd9topg-1bgtI"
if [ "$network" = "localhost" ] || [ "$network" = "localnet" ]; then
    network="http://127.0.0.1:8899"
fi
solana config set --keypair $deployerKeypair  --url $network

# fund your wallet for localnet or devnet
if [ "$network" = "devnet" ] || [ "$network" = "http://127.0.0.1:8899" ]; then
    echo "Airdropping 5 SOL to deployer"
    solana airdrop 5  
fi

# build the program
yarn build

# deploy program
anchor deploy --program-name smart_account_program --provider.cluster $network

# get program info
programId=$(solana address -k target/deploy/smart_account_program-keypair.json)
solana program show $programId