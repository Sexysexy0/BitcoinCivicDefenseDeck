// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AyudaOverrideLedger {
    event OverrideLogged(address indexed steward, uint256 amount, string reason, uint256 timestamp);

    function logOverride(address steward, uint256 amount, string memory reason) external {
        emit OverrideLogged(steward, amount, reason, block.timestamp);
    }
}
