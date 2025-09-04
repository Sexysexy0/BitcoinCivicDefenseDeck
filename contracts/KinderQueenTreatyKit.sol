// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract KinderQueenTreatyKit {
    struct Treaty {
        string name;
        string emotion;
        uint256 timestamp;
    }

    Treaty[] public treaties;

    function declareTreaty(string memory name, string memory emotion) external {
        treaties.push(Treaty(name, emotion, block.timestamp));
    }
}
