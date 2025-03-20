//SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

struct TransferToAgentOwnerMsg {
    address agentOwner;
}

contract DecodersForL2 {

    /**
     * @dev Decodes user signatures on all CCIP messages to EigenAgents
     * @param message is a CCIP message to Eigenlayer
     * @param sigOffset is the offset where the user signature begins
     */
    function decodeAgentOwnerSignature(bytes memory message, uint256 sigOffset) public pure returns (
        address agentOwner,
        uint256 expiry,
        bytes memory signature
    ) {

        bytes32 r;
        bytes32 s;
        bytes1 v;

        assembly {
            agentOwner := mload(add(message, sigOffset))
            expiry := mload(add(message, add(sigOffset, 32)))
            r := mload(add(message, add(sigOffset, 64)))
            s := mload(add(message, add(sigOffset, 96)))
            v := mload(add(message, add(sigOffset, 128)))
        }

        signature = abi.encodePacked(r, s, v);

        return (
            agentOwner,
            expiry,
            signature
        );
    }

    /**
     * @dev This message is dispatched from L1 to L2 by ReceiverCCIP.sol
     * @param message CCIP message to Eigenlayer
     * @return transferToAgentOwnerMsg contains the agentOwner which is sent back to L2
     */
    function decodeTransferToAgentOwnerMsg(bytes memory message)
        public pure
        returns (TransferToAgentOwnerMsg memory transferToAgentOwnerMsg)
    {
        //////////////////////// Message offsets //////////////////////////
        // 0000000000000000000000000000000000000000000000000000000000000020 [32]
        // 0000000000000000000000000000000000000000000000000000000000000064 [64]
        // d8a85b48                                                         [96] function selector
        // dd900ac4d233ec9d74ac5af4ce89f87c78781d8fd9ee2aad62d312bdfdf78a14 [100] agentOwner
        // 00000000000000000000000000000000000000000000000000000000

        bytes4 functionSelector;
        address agentOwner;

        assembly {
            functionSelector := mload(add(message, 96))
            agentOwner := mload(add(message, 100))
        }

        return TransferToAgentOwnerMsg({
            agentOwner: agentOwner
        });
    }
}
