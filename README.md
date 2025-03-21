## ZkSync L2 Restaking

Install ZkSync foundry: https://foundry-book.zksync.io/getting-started/installation

list all foundry versions installed:
```
foundryup --list
```

Then switch to zksync's foundry:
```
foundryup --use foundry_zksync_v0.0.11
```

Check forge version:
```
forge --version
# forge Version: 1.0.0-foundry-zksync-v0.0.11
# Commit SHA: ca5db06c7f7315aac75d5eeba944866b145f808a
# Build Timestamp: 2025-03-10T15:06:46.963797000Z (1741619206)
# Build Profile: release
```

We won't use hardhat, just foundry


Then install specific lib dependencies:
```
# CCIP v2.17.0
forge install https://github.com/smartcontractkit/ccip@v2.17.0-ccip1.5.16

# Eigenlayer v1.3.0
forge install git@github.com/Layr-Labs/eigenlayer-contracts@v1.3.0
```

### Build

```shell
forge build
```

### Deploy

Set values in `.env` for deployer private key
```
cp env.example .env
```

Run:
```shell
 sh script/2_deploySenderOnL2.sh
```
