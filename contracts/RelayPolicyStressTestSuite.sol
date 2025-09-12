// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RelayPolicyStressTestSuite {
    struct PayloadTest {
        uint256 size;
        uint256 fee;
        bool relayed;
        string relayNode;
        uint256 timestamp;
        bool flagged;
    }

    mapping(uint256 => PayloadTest) public testLog;
    uint256 public testCount;

    event PayloadTested(uint256 id, uint256 size, bool relayed);

    function logTest(
        uint256 size,
        uint256 fee,
        bool relayed,
        string memory relayNode,
        uint256 timestamp,
        bool flagged
    ) public {
        testLog[testCount] = PayloadTest(
            size,
            fee,
            relayed,
            relayNode,
            timestamp,
            flagged
        );
        emit PayloadTested(testCount, size, relayed);
        testCount++;
    }

    function getTest(uint256 id) public view returns (PayloadTest memory) {
        return testLog[id];
    }
}
