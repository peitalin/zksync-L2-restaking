// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {TransparentUpgradeableProxy} from "@openzeppelin-v5-contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";

import {FileReader} from "./FileReader.sol";
import {SenderCCIP} from "../src/SenderCCIP.sol";
import {ISenderCCIP} from "../src/interfaces/ISenderCCIP.sol";
import {SenderHooks} from "../src/SenderHooks.sol";
import {ISenderHooks} from "../src/interfaces/ISenderHooks.sol";
import {BaseSepolia, EthSepolia} from "./Addresses.sol";


contract DeploySenderOnL2Script is Script, FileReader {

    uint256 deployerKey = vm.envUint("DEPLOYER_KEY");
    address deployer = vm.addr(deployerKey);

    function run() public returns (ISenderCCIP, ISenderHooks) {
        // Print deployment information for debugging
        console2.log("Starting deployment with deployer:", deployer);
        uint256 deployerBalance = address(deployer).balance;
        console2.log("Deployer balance:", deployerBalance);

        // For zkSync, ensure we're using appropriate broadcast settings
        vm.startBroadcast(deployerKey);
        console2.log("Broadcast started");

        // Deploy contracts with clear logging to track progress
        console2.log("Step 1: Deploying implementation contracts");

        console2.log("Deploying SenderHooks implementation...");
        SenderHooks senderHooksImpl = new SenderHooks();
        console2.log("SenderHooks implementation deployed at:", address(senderHooksImpl));

        console2.log("Deploying SenderCCIP implementation...");
        SenderCCIP senderImpl = new SenderCCIP(BaseSepolia.Router);
        console2.log("SenderCCIP implementation deployed at:", address(senderImpl));

        // Deploy proxies with detailed error information
        console2.log("Step 2: Deploying proxies");

        console2.log("Preparing SenderHooks proxy initialization data...");
        bytes memory senderHooksInitData = abi.encodeWithSelector(
            SenderHooks.initialize.selector,
            EthSepolia.BridgeToken,
            BaseSepolia.BridgeToken
        );

        console2.log("Deploying SenderHooks proxy...");
        TransparentUpgradeableProxy senderHooksProxyContract = new TransparentUpgradeableProxy(
            address(senderHooksImpl),
            deployer,
            senderHooksInitData
        );
        SenderHooks senderHooksProxy = SenderHooks(payable(address(senderHooksProxyContract)));
        console2.log("SenderHooks proxy deployed at:", address(senderHooksProxy));

        console2.log("Preparing SenderCCIP proxy initialization data...");
        bytes memory senderCCIPInitData = abi.encodeWithSelector(
            SenderCCIP.initialize.selector
        );

        console2.log("Deploying SenderCCIP proxy...");
        TransparentUpgradeableProxy senderCCIPProxyContract = new TransparentUpgradeableProxy(
            address(senderImpl),
            deployer,
            senderCCIPInitData
        );
        SenderCCIP senderProxy = SenderCCIP(payable(address(senderCCIPProxyContract)));
        console2.log("SenderCCIP proxy deployed at:", address(senderProxy));

        // Configure contracts with step-by-step logging
        console2.log("Step 3: Configuring contracts");

        console2.log("Whitelisting destination chain:", EthSepolia.ChainSelector);
        senderProxy.allowlistDestinationChain(EthSepolia.ChainSelector, true);

        console2.log("Whitelisting source chain:", EthSepolia.ChainSelector);
        senderProxy.allowlistSourceChain(EthSepolia.ChainSelector, true);

        console2.log("Setting SenderHooks in SenderCCIP...");
        senderProxy.setSenderHooks(ISenderHooks(address(senderHooksProxy)));

        console2.log("Setting SenderCCIP in SenderHooks...");
        senderHooksProxy.setSenderCCIP(address(senderProxy));

        // Verify configurations with explicit checks
        console2.log("Step 4: Verifying configurations");

        address hookAddress = address(senderProxy.getSenderHooks());
        console2.log("Configured SenderHooks address:", hookAddress);
        require(
            hookAddress == address(senderHooksProxy),
            string(abi.encodePacked("senderProxy: missing senderHooks, got: ", vm.toString(hookAddress)))
        );

        address ccipAddress = address(senderHooksProxy.getSenderCCIP());
        console2.log("Configured SenderCCIP address:", ccipAddress);
        require(
            ccipAddress == address(senderProxy),
            string(abi.encodePacked("senderHooksProxy: missing senderCCIP, got: ", vm.toString(ccipAddress)))
        );

        bool sourceChainAllowed = senderProxy.allowlistedSourceChains(EthSepolia.ChainSelector);
        console2.log("Source chain allowlisted:", sourceChainAllowed ? "yes" : "no");
        require(
            sourceChainAllowed,
            "senderProxy: must allowlist SourceChain: EthSepolia"
        );

        bool destChainAllowed = senderProxy.allowlistedDestinationChains(EthSepolia.ChainSelector);
        console2.log("Destination chain allowlisted:", destChainAllowed ? "yes" : "no");
        require(
            destChainAllowed,
            "senderProxy: must allowlist DestinationChain: EthSepolia"
        );

        // Save deployment information
        console2.log("Step 5: Saving deployment information");
        saveSenderBridgeContracts(
            address(senderProxy),
            address(senderHooksProxy),
            FILEPATH_BRIDGE_CONTRACTS_L2
        );
        console2.log("Deployment information saved to:", FILEPATH_BRIDGE_CONTRACTS_L2);

        console2.log("Deployment completed successfully!");
        vm.stopBroadcast();

        return (
            ISenderCCIP(address(senderProxy)),
            ISenderHooks(address(senderHooksProxy))
        );
    }
}