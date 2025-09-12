// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PayloadFlagSanctifier {
    enum FlagType { Neutral, Urgent, HighAPR, CivicEmergency, ReputationalRisk, Unknown }

    struct PayloadFlag {
        uint256 payloadId;
        FlagType flagType;
        string reason;
        string taggedBy;
        uint256 timestamp;
        bool verified;
    }

    mapping(uint256 => PayloadFlag) public flagLog;
    uint256 public flagCount;

    event FlagSanctified(uint256 id, FlagType flagType, string taggedBy);

    function sanctifyFlag(
        uint256 payloadId,
        FlagType flagType,
        string memory reason,
        string memory taggedBy,
        uint256 timestamp
    ) public {
        flagLog[flagCount] = PayloadFlag(
            payloadId,
            flagType,
            reason,
            taggedBy,
            timestamp,
            false
        );
        emit FlagSanctified(flagCount, flagType, taggedBy);
        flagCount++;
    }

    function verifyFlag(uint256 id) public {
        flagLog[id].verified = true;
    }

    function getFlag(uint256 id) public view returns (PayloadFlag memory) {
        return flagLog[id];
    }
}
