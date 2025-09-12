// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PayloadBlessingRouter {
    enum PayloadType { Notary, RWA, Timestamp, NFT, CivicFlag, Unknown }

    struct Payload {
        uint256 size;
        uint256 fee;
        PayloadType payloadType;
        string originNode;
        bool blessed;
        uint256 timestamp;
    }

    mapping(uint256 => Payload) public payloadLog;
    uint256 public payloadCount;

    event PayloadBlessed(uint256 id, PayloadType payloadType, string originNode);

    function blessPayload(
        uint256 size,
        uint256 fee,
        PayloadType payloadType,
        string memory originNode,
        uint256 timestamp
    ) public {
        require(size <= 2048, "Payload too large");
        require(fee >= dynamicFeeFloor(size), "Fee too low");

        payloadLog[payloadCount] = Payload(
            size,
            fee,
            payloadType,
            originNode,
            true,
            timestamp
        );

        emit PayloadBlessed(payloadCount, payloadType, originNode);
        payloadCount++;
    }

    function dynamicFeeFloor(uint256 size) public pure returns (uint256) {
        // Simple elasticity model: 1 sat/byte minimum
        return size * 1;
    }

    function getPayload(uint256 id) public view returns (Payload memory) {
        return payloadLog[id];
    }
}
