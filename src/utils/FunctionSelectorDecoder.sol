// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";


contract FunctionSelectorDecoder {

    /// @dev Decodes leading bytes4 in the string message
    /// @param message is the CCIP Any2EVMMessage.data payload: an abi.encoded string
    function decodeFunctionSelector(bytes memory message)
        public
        pure
        returns (bytes4 functionSelector)
    {
        // CCIP abi.encodes(string(message)) messages, adding 64 bytes. functionSelector begins at 0x60 (96)
        assembly {
            // string_offset := mload(add(message, 0x20))
            // string_length := mload(add(message, 0x40))
            functionSelector := mload(add(message, 0x60))
        }
    }
}



