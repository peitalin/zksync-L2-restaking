// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {TransparentUpgradeableProxy} from "@openzeppelin-v5-contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import {Script} from "forge-std/Script.sol";

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

        vm.startBroadcast(deployerKey);

        // deploy sender hooks implementation first, step-by-step
        SenderHooks senderHooksImpl = new SenderHooks();
        // deploy sender utils proxy
        SenderHooks senderHooksProxy = SenderHooks(
            payable(address(
                new TransparentUpgradeableProxy(
                    address(senderHooksImpl),
                    address(deployer),
                    abi.encodeWithSelector(
                        SenderHooks.initialize.selector,
                        EthSepolia.BridgeToken,
                        BaseSepolia.BridgeToken
                    )
                )
            ))
        );

        SenderCCIP senderImpl = new SenderCCIP(BaseSepolia.Router);
        // Deployer, not proxy admin for 2nd argument in TransparentUpgradeableProxy constructor
        // https://forum.openzeppelin.com/t/5-0-transparentupgradeableproxy-upgradeandcall-error/41540/2
        SenderCCIP senderProxy = SenderCCIP(
            payable(address(
                new TransparentUpgradeableProxy(
                    address(senderImpl),
                    address(deployer),
                    abi.encodeWithSelector(SenderCCIP.initialize.selector)
                )
            ))
        );

        // whitelist both chain to receive and send messages
        senderProxy.allowlistDestinationChain(EthSepolia.ChainSelector, true);
        senderProxy.allowlistSourceChain(EthSepolia.ChainSelector, true);
        senderProxy.setSenderHooks(ISenderHooks(address(senderHooksProxy)));

        senderHooksProxy.setSenderCCIP(address(senderProxy));

        require(
            address(senderProxy.getSenderHooks()) != address(0),
            "senderProxy: missing senderHooks"
        );
        require(
            address(senderHooksProxy.getSenderCCIP()) != address(0),
            "senderHooksProxy: missing senderCCIP"
        );
        require(
            senderProxy.allowlistedSourceChains(EthSepolia.ChainSelector),
            "senderProxy: must allowlist SourceChain: EthSepolia"
        );
        require(
            senderProxy.allowlistedDestinationChains(EthSepolia.ChainSelector),
            "senderProxy: must allowlist DestinationChain: EthSepolia)"
        );

        saveSenderBridgeContracts(
            address(senderProxy),
            address(senderHooksProxy),
            FILEPATH_BRIDGE_CONTRACTS_L2
        );

        vm.stopBroadcast();

        return (
            ISenderCCIP(address(senderProxy)),
            ISenderHooks(address(senderHooksProxy))
        );
    }
}