// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SaltTyphoonFirewall {
    address public steward;

    struct ThreatSignal {
        string origin;
        string vector;
        string payloadType;
        bool quarantined;
        uint256 timestamp;
    }

    ThreatSignal[] public quarantinedSignals;
    mapping(string => bool) public flaggedVectors;

    event SignalQuarantined(string origin, string vector, string payloadType, uint256 timestamp);
    event VectorFlagged(string vector, uint256 timestamp);
    event VectorCleared(string vector, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    function quarantineSignal(string memory origin, string memory vector, string memory payloadType) external onlySteward {
        quarantinedSignals.push(ThreatSignal(origin, vector, payloadType, true, block.timestamp));
        emit SignalQuarantined(origin, vector, payloadType, block.timestamp);
    }

    function flagVector(string memory vector) external onlySteward {
        flaggedVectors[vector] = true;
        emit VectorFlagged(vector, block.timestamp);
    }

    function clearVector(string memory vector) external onlySteward {
        flaggedVectors[vector] = false;
        emit VectorCleared(vector, block.timestamp);
    }

    function isFlagged(string memory vector) external view returns (bool) {
        return flaggedVectors[vector];
    }

    function getQuarantinedSignal(uint256 index) external view returns (ThreatSignal memory) {
        require(index < quarantinedSignals.length, "Signal index out of bounds");
        return quarantinedSignals[index];
    }

    function totalQuarantined() external view returns (uint256) {
        return quarantinedSignals.length;
    }
}
