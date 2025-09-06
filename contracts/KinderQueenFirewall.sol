// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract KinderQueenFirewall {
    address public steward;
    uint256 public threshold;

    struct Packet {
        string origin;
        string contentType;
        uint256 emotionalAPR;
        bool allowed;
    }

    Packet[] public filteredPackets;

    event PacketFiltered(string origin, string contentType, uint256 emotionalAPR, bool allowed);
    event ThresholdUpdated(uint256 newThreshold);

    constructor(uint256 initialThreshold) {
        steward = msg.sender;
        threshold = initialThreshold;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    function filterPacket(string memory origin, string memory contentType, uint256 emotionalAPR) external onlySteward {
        bool allowed = emotionalAPR >= threshold;
        filteredPackets.push(Packet(origin, contentType, emotionalAPR, allowed));
        emit PacketFiltered(origin, contentType, emotionalAPR, allowed);
    }

    function updateThreshold(uint256 newThreshold) external onlySteward {
        threshold = newThreshold;
        emit ThresholdUpdated(newThreshold);
    }

    function getPacket(uint256 index) external view returns (Packet memory) {
        require(index < filteredPackets.length, "Packet index out of bounds");
        return filteredPackets[index];
    }

    function totalPackets() external view returns (uint256) {
        return filteredPackets.length;
    }
}
