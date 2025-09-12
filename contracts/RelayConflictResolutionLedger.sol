// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RelayConflictResolutionLedger {
    struct StakeholderSignal {
        string name;
        string role;
        string position;
        string consequence;
        uint256 timestamp;
        bool verified;
    }

    mapping(uint256 => StakeholderSignal) public signalLog;
    uint256 public signalCount;

    event SignalLogged(uint256 id, string name, string position);

    function logSignal(
        string memory name,
        string memory role,
        string memory position,
        string memory consequence,
        uint256 timestamp
    ) public {
        signalLog[signalCount] = StakeholderSignal(
            name,
            role,
            position,
            consequence,
            timestamp,
            false
        );
        emit SignalLogged(signalCount, name, position);
        signalCount++;
    }

    function verifySignal(uint256 id) public {
        signalLog[id].verified = true;
    }

    function getSignal(uint256 id) public view returns (StakeholderSignal memory) {
        return signalLog[id];
    }
}
