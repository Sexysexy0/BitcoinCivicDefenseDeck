// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title BarangaySanctumRegistry
/// @dev Registers sanctums and validates node blessings for local sovereignty.

contract BarangaySanctumRegistry {
    struct Sanctum {
        string name;
        string region;
        address steward;
        uint256 timestamp;
    }

    mapping(address => Sanctum) public sanctums;
    event SanctumRegistered(address indexed steward, string name, string region, uint256 timestamp);

    function registerSanctum(string memory name, string memory region) public {
        sanctums[msg.sender] = Sanctum(name, region, msg.sender, block.timestamp);
        emit SanctumRegistered(msg.sender, name, region, block.timestamp);
    }

    function getSanctum(address steward) public view returns (Sanctum memory) {
        return sanctums[steward];
    }
}
