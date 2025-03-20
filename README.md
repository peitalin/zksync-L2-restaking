## ZkSync L2 Restaking


## Dev Documentation

Install ZkSync foundry:
https://foundry-book.zksync.io/getting-started/installation

list all foundry versions installed:
```
foundryup --list
```

Switch to zksync's foundry:
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

Then run:
```
pnpm install
```
to install Hardhat and related ZkSync dependencies


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
