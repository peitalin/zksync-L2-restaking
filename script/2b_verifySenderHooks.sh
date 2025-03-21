#!/bin/bash
source .env

forge verify-contract \
    --watch \
    --zksync \
    --rpc-url treasureTopaz \
    --verifier zksync \
    --verifier-url "https://rpc-explorer-verify.topaz.treasure.lol/contract_verification" \
    0x4025F5d7ee1017DF0E21755A01Dd5bD1Af9727dc \
    src/SenderHooks.sol:SenderHooks


