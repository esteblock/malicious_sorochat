#! /bin/bash

NETWORK="standalone"
SOROBAN_RPC_HOST="http://localhost:8000"
SOROBAN_RPC_URL="$SOROBAN_RPC_HOST/soroban/rpc"
FRIENDBOT_URL="$SOROBAN_RPC_HOST/friendbot"
SOROBAN_NETWORK_PASSPHRASE="Standalone Network ; February 2017"

echo Adding network
soroban config network add "$NETWORK" \
  --rpc-url "$SOROBAN_RPC_URL" \
  --network-passphrase "$SOROBAN_NETWORK_PASSPHRASE"
echo ---

soroban config identity generate my-account \
    --rpc-url "$SOROBAN_RPC_URL" \
    --network-passphrase "$SOROBAN_NETWORK_PASSPHRASE" \
    --network standalone

MY_ACCOUNT_ADDRESS="$(soroban config identity address my-account)"
curl  --silent -X POST "$FRIENDBOT_URL?addr=$MY_ACCOUNT_ADDRESS" > null
ARGS="--network standalone --source-account my-account"

echo Wrapping token
TOKEN_ADDRESS=$(soroban lab token wrap $ARGS --asset native)
echo Wrapped with address result: $TOKEN_ADDRESS
echo ---

echo Wrapping might fail if it was done before, so we are also getting the address:
TOKEN_ADDRESS="$(soroban lab token id --asset native --network standalone --source-account my-account)"
echo Native token address: $TOKEN_ADDRESS
echo ---

SPENDER=GDTQJYXRZZFOKR3NZ7H3QMQSMFQMAUOF43FZHTMKD6QFP5HBQK7VEZST
soroban contract invoke   --network standalone --source-account my-account  --id "$TOKEN_ADDRESS"   --   approve   --from $MY_ACCOUNT_ADDRESS   --spender $SPENDER  --amount 5 --expiration-ledger 999999 

TO=GDTQJYXRZZFOKR3NZ7H3QMQSMFQMAUOF43FZHTMKD6QFP5HBQK7VEZST
soroban contract invoke   --network standalone --source-account my-account  --id "$TOKEN_ADDRESS"   --   transfer   --from $MY_ACCOUNT_ADDRESS   --to $TO  --amount 50000000

USER=GDTQJYXRZZFOKR3NZ7H3QMQSMFQMAUOF43FZHTMKD6QFP5HBQK7VEZST
soroban contract invoke   --network standalone --source-account my-account  --id "$TOKEN_ADDRESS"   --   balance   --id $USER
