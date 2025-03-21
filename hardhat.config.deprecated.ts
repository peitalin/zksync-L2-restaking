import "dotenv/config";
import "hardhat-deploy";
import "@treasure-dev/hardhat-kms";
import "@matterlabs/hardhat-zksync";
import "@matterlabs/hardhat-zksync-verify";
import "@nomicfoundation/hardhat-foundry";
import { HardhatUserConfig, task } from "hardhat/config";
import 'solidity-docgen';

const devKmsKey = process.env.DEV_KMS_RESOURCE_ID;
const prodKmsKey = process.env.PROD_KMS_RESOURCE_ID;
// Private key for development (if using private key instead of KMS)
const privateKey = process.env.DEPLOYER_KEY;

const config: HardhatUserConfig = {
  defaultNetwork: "treasureTopaz",
  networks: {
    zkSyncSepolia: {
      url: process.env.ZKSYNC_SEPOLIA_RPC ?? "",
      ethNetwork: "sepolia",
      zksync: true,
      verifyURL:
        "https://explorer.sepolia.era.zksync.dev/contract_verification",
      // You can use either kmsKeyId or private key (accounts)
      // kmsKeyId: devKmsKey,
      // Uncomment the line below and comment the kmsKeyId line to use private key instead
      accounts: privateKey ? [privateKey] : undefined,
    },
    treasureTopaz: {
      url: process.env.TREASURE_TOPAZ_RPC ?? "",
      ethNetwork: "sepolia",
      zksync: true,
      verifyURL:
        "https://rpc-explorer-verify.topaz.treasure.lol/contract_verification",
      // You can use either kmsKeyId or private key (accounts)
      // kmsKeyId: devKmsKey,
      // Uncomment the line below and comment the kmsKeyId line to use private key instead
      accounts: privateKey ? [privateKey] : undefined,
    },
    treasureMainnet: {
      url: `${process.env.TREASURE_MAINNET_RPC}`,
      // You can use either kmsKeyId or private key (accounts)
      kmsKeyId: prodKmsKey,
      // Uncomment the line below and comment the kmsKeyId line to use private key instead
      // accounts: privateKey ? [privateKey] : undefined,
      ethNetwork: "mainnet",
      chainId: 0xeeee,
      live: true,
      saveDeployments: true,
      gasMultiplier: 2,
      verifyURL:
        "https://rpc-explorer-verify.treasure.lol/contract_verification",
      zksync: true,
    },
    dockerizedNode: {
      url: "http://localhost:3050",
      ethNetwork: "http://localhost:8545",
      zksync: true,
    },
    inMemoryNode: {
      url: "http://127.0.0.1:8011",
      ethNetwork: "localhost", // in-memory node doesn't support eth node; removing this line will cause an error
      zksync: true,
    },
    hardhat: {
      zksync: true,
    },
  },
  zksolc: {
    version: "1.5.11",
    settings: {
      // find all available options in the official umentation
      // https://docs.zksync.io/build/tooling/hardhat/hardhat-zksync-solc#configuration
    },
  },
  solidity: {
    version: "0.8.28",
    settings: {
      evmVersion: "cancun",
    }
  },
  namedAccounts: {
    deployer: 0,
  },
  docgen: {
    outputDir: "docs",
    pages: "files",
    exclude: ["ForceBeaconProxy"]
  }
};

export default config;
