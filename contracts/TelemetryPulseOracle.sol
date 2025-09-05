// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

contract TelemetryPulseOracle {
    struct PulseLog {
        string signalType;
        uint256 emotionalAPR;
        string source;
        bool sanctified;
        uint256 timestamp;
    }

    mapping(address => PulseLog[]) public pulseRegistry;
    event PulseRecorded(address indexed device, string signalType, uint256 emotionalAPR, string source, bool sanctified, uint256 timestamp);

    function recordPulse(address device, string calldata signalType, uint256 apr, string calldata source, bool sanctified) external {
        require(apr >= 0 && apr <= 20, "Invalid Emotional APR");

        pulseRegistry[device].push(PulseLog(signalType, apr, source, sanctified, block.timestamp));
        emit PulseRecorded(device, signalType, apr, source, sanctified, block.timestamp);
    }

    function getLatestPulse(address device) external view returns (PulseLog memory) {
        uint256 len = pulseRegistry[device].length;
        require(len > 0, "No pulse recorded");
        return pulseRegistry[device][len - 1];
    }

    function getPulseCount(address device) external view returns (uint256) {
        return pulseRegistry[device].length;
    }
}
