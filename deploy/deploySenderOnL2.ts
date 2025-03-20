import type { HardhatRuntimeEnvironment } from "hardhat/types";
import type { DeployFunction } from "hardhat-deploy/types";
import fs from "fs";
import path from "path";
import { ethers } from "ethers";

// Chain constants
const BaseSepolia = {
  Router: "0xD3b06cEbF099CE7DA4AcCf578aaebFDBd6e88a93",
  ChainSelector: "10344971235874465080",
  BridgeToken: "0x886330448089754e998BcEfa2a56a91aD240aB60",
};

const EthSepolia = {
  Router: "0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59",
  ChainSelector: "16015286601757825753",
  BridgeToken: "0xAf03f2a302A2C4867d622dE44b213b8F870c0f1a",
};

// Helper function to save bridge contract addresses
const saveSenderBridgeContracts = (
  senderCCIP: string,
  senderHooks: string,
  filePath: string
) => {
  const data = {
    contracts: {
      senderCCIP,
      senderHooks,
    },
    chainInfo: {
      block: 0, // This will be updated with real block number after deployment
      timestamp: Math.floor(Date.now() / 1000),
      chainid: 0, // This will be updated with real chain ID after deployment
    },
  };

  const dirPath = path.dirname(filePath);
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }

  fs.writeFileSync(filePath, JSON.stringify(data, null, 2));
  console.log(`Bridge contracts data saved to ${filePath}`);
};

const func: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
  const { getNamedAccounts, deployments, network } = hre;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  // Define file path for storing contract addresses
  const FILEPATH_BRIDGE_CONTRACTS_L2 = "script/treasureTopaz/bridgeContractsL2.config.json";

  console.log("Deploying SenderOnL2 contracts...");
  console.log(`Deployer address: ${deployer}`);

  // Set higher gas limits for zkSync deployments
  const gasLimit = 10000000; // Increased gas limit
  const overrides = {
    gasLimit,
  };

  // Deploy SenderHooks implementation
  console.log("Deploying SenderHooks implementation...");
  const senderHooksImpl = await deploy("SenderHooks", {
    from: deployer,
    log: true,
    gasLimit,
    waitConfirmations: 1,
  });
  console.log(`SenderHooks implementation deployed at: ${senderHooksImpl.address}`);

  // Deploy SenderHooks proxy
  console.log("Deploying SenderHooks proxy...");
  const senderHooksProxy = await deploy("SenderHooks_Proxy", {
    contract: "TransparentUpgradeableProxy",
    from: deployer,
    args: [
      senderHooksImpl.address,
      deployer,
      ethers.AbiCoder.defaultAbiCoder().encode(
        ["bytes4", "address", "address"],
        [
          // SenderHooks.initialize.selector
          "0xc0c53b8b",
          EthSepolia.BridgeToken,
          BaseSepolia.BridgeToken
        ]
      ),
    ],
    log: true,
    gasLimit,
    waitConfirmations: 1,
  });
  console.log(`SenderHooks proxy deployed at: ${senderHooksProxy.address}`);

  // Deploy SenderCCIP implementation
  console.log("Deploying SenderCCIP implementation...");
  const senderCCIPImpl = await deploy("SenderCCIP", {
    from: deployer,
    args: [BaseSepolia.Router],
    log: true,
    gasLimit,
    waitConfirmations: 1,
  });
  console.log(`SenderCCIP implementation deployed at: ${senderCCIPImpl.address}`);

  // Deploy SenderCCIP proxy
  console.log("Deploying SenderCCIP proxy...");
  const senderCCIPProxy = await deploy("SenderCCIP_Proxy", {
    contract: "TransparentUpgradeableProxy",
    from: deployer,
    args: [
      senderCCIPImpl.address,
      deployer,
      ethers.AbiCoder.defaultAbiCoder().encode(
        ["bytes4"],
        [
          // SenderCCIP.initialize.selector
          "0x8129fc1c"
        ]
      ),
    ],
    log: true,
    gasLimit,
    waitConfirmations: 1,
  });
  console.log(`SenderCCIP proxy deployed at: ${senderCCIPProxy.address}`);

  // Get contract instances
  const senderCCIP = await hre.ethers.getContractAt("SenderCCIP", senderCCIPProxy.address);
  const senderHooks = await hre.ethers.getContractAt("SenderHooks", senderHooksProxy.address);

  // Configure contracts
  console.log("Configuring contracts...");

  try {
    // Whitelist destination and source chains
    console.log("Whitelisting chains...");
    await (await senderCCIP.allowlistDestinationChain(EthSepolia.ChainSelector, true, overrides)).wait();
    await (await senderCCIP.allowlistSourceChain(EthSepolia.ChainSelector, true, overrides)).wait();

    // Set SenderHooks in SenderCCIP
    console.log("Setting SenderHooks in SenderCCIP...");
    await (await senderCCIP.setSenderHooks(senderHooksProxy.address, overrides)).wait();

    // Set SenderCCIP in SenderHooks
    console.log("Setting SenderCCIP in SenderHooks...");
    await (await senderHooks.setSenderCCIP(senderCCIPProxy.address, overrides)).wait();

    // Verify configurations
    console.log("Verifying configurations...");

    const configuredSenderHooks = await senderCCIP.getSenderHooks({ gasLimit });
    if (configuredSenderHooks !== senderHooksProxy.address) {
      throw new Error("senderProxy: missing senderHooks");
    }

    const configuredSenderCCIP = await senderHooks.getSenderCCIP({ gasLimit });
    if (configuredSenderCCIP !== senderCCIPProxy.address) {
      throw new Error("senderHooksProxy: missing senderCCIP");
    }

    const isSourceChainAllowlisted = await senderCCIP.allowlistedSourceChains(EthSepolia.ChainSelector, { gasLimit });
    if (!isSourceChainAllowlisted) {
      throw new Error("senderProxy: must allowlist SourceChain: EthSepolia");
    }

    const isDestinationChainAllowlisted = await senderCCIP.allowlistedDestinationChains(EthSepolia.ChainSelector, { gasLimit });
    if (!isDestinationChainAllowlisted) {
      throw new Error("senderProxy: must allowlist DestinationChain: EthSepolia");
    }
  } catch (error) {
    console.error("Error during contract configuration:", error);
    throw error;
  }

  // Save contract addresses
  const block = await hre.ethers.provider.getBlock("latest");
  console.log("Saving contract addresses...");
  saveSenderBridgeContracts(
    senderCCIPProxy.address,
    senderHooksProxy.address,
    FILEPATH_BRIDGE_CONTRACTS_L2
  );

  // Update saved file with actual block number and chain ID
  const data = JSON.parse(fs.readFileSync(FILEPATH_BRIDGE_CONTRACTS_L2, "utf8"));
  data.chainInfo.block = block.number;
  data.chainInfo.chainid = network.config.chainId;
  fs.writeFileSync(FILEPATH_BRIDGE_CONTRACTS_L2, JSON.stringify(data, null, 2));

  console.log("Deployment and configuration completed successfully!");
  console.log(`SenderCCIP deployed at: ${senderCCIPProxy.address}`);
  console.log(`SenderHooks deployed at: ${senderHooksProxy.address}`);
};

export default func;
func.tags = ["sender", "l2"];