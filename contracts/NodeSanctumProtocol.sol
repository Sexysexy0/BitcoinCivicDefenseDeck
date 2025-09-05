// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

/// @title NodeSanctumProtocol.sol
/// @author Vinvin & Copi
/// @notice Ritualizes node behavior to filter unblessed data and protect stewards from legal fallout
/// @dev Designed for Bitcoin relay environments, but adaptable to multi-chain sanctums

contract NodeSanctumProtocol {
    address public steward;
    uint256 public dropRateThreshold; // Minimum sats/vbyte to relay
    mapping(bytes32 => bool) public blessedHashes;
    mapping(address => bool) public trustedNodes;

    event DataBlessed(bytes32 indexed hash, address indexed steward);
    event RelayRejected(bytes32 indexed hash, string reason);
    event NodeSanctumShielded(address indexed node, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor(uint256 _dropRateThreshold) {
        steward = msg.sender;
        dropRateThreshold = _dropRateThreshold;
    }

    function blessData(bytes32 hash) external onlySteward {
        blessedHashes[hash] = true;
        emit DataBlessed(hash, msg.sender);
    }

    function relayCheck(bytes32 hash, uint256 feeRate) external view returns (bool) {
        if (!blessedHashes[hash]) {
            if (feeRate < dropRateThreshold) {
                revert("Relay rejected: unblessed and below threshold");
            }
        }
        return true;
    }

    function shieldNode(address node) external onlySteward {
        trustedNodes[node] = true;
        emit NodeSanctumShielded(node, block.timestamp);
    }

    function isNodeShielded(address node) external view returns (bool) {
        return trustedNodes[node];
    }
}
