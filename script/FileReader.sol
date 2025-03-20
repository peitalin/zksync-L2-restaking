// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script, stdJson} from "forge-std/Script.sol";
import {ISenderCCIP} from "../src/interfaces/ISenderCCIP.sol";
import {ISenderHooks} from "../src/interfaces/ISenderHooks.sol";


contract FileReader is Script {

    string public FILEPATH_BRIDGE_CONTRACTS_L1 = "script/ethsepolia/bridgeContractsL1.config.json";
    string public FILEPATH_BRIDGE_CONTRACTS_L2 = "script/treasureTopaz/bridgeContractsL2.config.json";

    /////////////////////////////////////////////////
    // L2 Contracts
    /////////////////////////////////////////////////

    function readSenderContract() public view returns (ISenderCCIP) {
        string memory addrData;
        addrData = vm.readFile(FILEPATH_BRIDGE_CONTRACTS_L2);
        address senderAddr = stdJson.readAddress(addrData, ".contracts.senderCCIP");
        return ISenderCCIP(senderAddr);
    }

    function readSenderHooks() public view returns (ISenderHooks) {
        string memory addrData;
        addrData = vm.readFile(FILEPATH_BRIDGE_CONTRACTS_L2);
        address senderHooksAddr = stdJson.readAddress(addrData, ".contracts.senderHooks");
        return ISenderHooks(senderHooksAddr);
    }

    /// @dev hardcoded chainid for contracts. Update for prod
    function saveSenderBridgeContracts(
        address senderCCIP,
        address senderHooks,
        string memory filePath
    ) public {
        // { "inputs": <inputs_data>}
        /////////////////////////////////////////////////
        vm.serializeAddress("contracts" , "senderCCIP", senderCCIP);
        string memory inputs_data = vm.serializeAddress("contracts" , "senderHooks", senderHooks);

        /////////////////////////////////////////////////
        // { "chainInfo": <chain_info_data>}
        /////////////////////////////////////////////////
        vm.serializeUint("chainInfo", "block", block.number);
        vm.serializeUint("chainInfo", "timestamp", block.timestamp);
        string memory chainInfo_data = vm.serializeUint("chainInfo", "chainid", block.chainid);

        /////////////////////////////////////////////////
        // combine objects to a root object
        /////////////////////////////////////////////////
        vm.serializeString("rootObject", "chainInfo", chainInfo_data);
        string memory finalJson2 = vm.serializeString("rootObject", "contracts", inputs_data);

        // chains[31337] = "localhost";
        // chains[17000] = "holesky";
        // chains[84532] = "basesepolia";
        // chains[11155111] = "ethsepolia";
        string memory finalOutputPath2 = string(abi.encodePacked(
            filePath
        ));
        vm.writeJson(finalJson2, finalOutputPath2);
    }
}
