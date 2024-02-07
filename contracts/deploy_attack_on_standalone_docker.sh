#! /bin/bash
echo -e "\n\n"
echo "Using Makefile to build contracts wasm blobs"

echo -e "\n\n"

make > /dev/null

echo -e "\n\n"

echo "Configuring soroban for standalone\n"
soroban config network add --global standalone \
  --rpc-url http://stellar-standalone:8000/soroban/rpc \
  --network-passphrase "Standalone Network ; February 2017"

echo "Configuring deployer identity"
soroban keys generate --no-fund --network standalone deployer

echo "Configuring user identity"
soroban keys generate --no-fund --network standalone user

echo "Configuring user2 identity"
soroban keys generate --no-fund --network standalone user2

echo -e "\n\n"

# DEPLOYER=$(soroban config identity address deployer)
DEPLOYER=$(soroban keys address deployer)
echo "Deployer address is $DEPLOYER"
USER=$(soroban keys address user)
echo "User address is $USER"

USER2=$(soroban keys address user2)
echo "User2 address is $USER2"

echo -e "\n\n"

echo "Funding deployer address with friendbot"
curl "http://stellar-standalone:8000/friendbot?addr=$DEPLOYER"

echo -e "\n\n"

echo "Funding user address with friendbot"
curl "http://stellar-standalone:8000/friendbot?addr=$USER"


echo "Funding user2 address with friendbot"
curl "http://stellar-standalone:8000/friendbot?addr=$USER2"


for contract_name in $@
do
    echo "Deploying $contract_name on standalone"
    CONTRACT_ID="$(soroban contract deploy \
    --wasm "./$contract_name/target/wasm32-unknown-unknown/release/$contract_name.wasm" \
    --source deployer \
    --network standalone)"
    echo "Contract successfully deployed on standalone with contract id $CONTRACT_ID"

    echo -e "\n\n"

    tmp=$(mktemp) 
    if [[ $(jq ".standalone.$contract_name" contracts_ids.json) ]]; then
        jq ".standalone.$contract_name = \"$CONTRACT_ID\"" contracts_ids.json > "$tmp" && mv "$tmp" contracts_ids.json
    else
        jq ".standalone += [{\"$contract_name\":\"$CONTRACT_ID\"}]" contracts_ids.json > "$tmp" && mv "$tmp" contracts_ids.json
    fi
done

echo -e "Check the address of the deployed contracts in contracts_ids.json:\n`cat contracts_ids.json`"

echo -e "\n\n"
echo -e "\n\n"

echo -e "XLM: Will try to wrap, it might fail if already wrapped"
# soroban lab token wrap --asset native --network standalone --source-account deployer
soroban contract asset deploy --asset native --network standalone --source-account deployer



echo -e "\n\n"
echo -e "\n\n"

# XLM_ADDRESS=$(soroban lab token id --asset native --network standalone --source-account deployer)
XLM_ADDRESS=$(soroban contract asset id --asset native --network standalone --source-account deployer)



echo -e "Deployer XLM balance. Using native XLM address: $XLM_ADDRESS and deployer address $DEPLOYER"

soroban contract invoke \
  --network standalone --source-account deployer \
  --id $XLM_ADDRESS \
  -- \
  balance \
  --id $DEPLOYER

echo -e "\n\n"
echo -e "\n\n"

echo -e "User XLM balance. Using native XLM address: $XLM_ADDRESS and user address $USER"
soroban contract invoke \
  --network standalone --source-account deployer \
  --id $XLM_ADDRESS \
  -- \
  balance \
  --id $USER

echo -e "\n\n"
echo -e "\n\n"

echo -e "Now the user will interact with the malicious sorochat."


# soroban contract invoke \
#   --network standalone --source user \
#   --id CAFWFGQNKTETGZVQ35XM2DNVQRVOOYXKZRVIC4C7NKL4JUN6Z3L2O7LJ \
#   -- \
#   write_message \
#   --from $USER \
#   --to $DEPLOYER \
#   --msd "Dont Hurt Me"
