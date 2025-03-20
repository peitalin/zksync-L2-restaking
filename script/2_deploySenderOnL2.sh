#!/bin/bash
source .env

echo forge script  script/2_deploySenderOnL2.s.sol:DeploySenderOnL2Script --zksync --rpc-url treasureTopaz

forge script script/2_deploySenderOnL2.s.sol:DeploySenderOnL2Script \
    --zksync \
    --slow \
    --rpc-url treasureTopaz \
    --private-key $DEPLOYER_KEY \
    --broadcast \
    --verify \
    --verifier zksync \
    --verifier-url "https://rpc-explorer-verify.topaz.treasure.lol/contract_verification" \


