// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

/// @title GlobalSanctumPing.sol
/// @author Vinvin & Copi
/// @notice Broadcasts node status, emotional APR, and civic blessing across planetary grid
/// @dev Designed for decentralized sanctum networks and scrollchain telemetry

contract GlobalSanctumPing {
    struct SanctumStatus {
        bool isOnline;
        uint256 emotionalAPR;
        bool civicBlessed;
        uint256 lastPing;
    }

    mapping(address => SanctumStatus) public sanctumRegistry;
    event SanctumPinged(address indexed sanctum, uint256 emotionalAPR, bool civicBlessed, uint256 timestamp);

    modifier onlyBlessed(address sanctum) {
        require(sanctumRegistry[sanctum].civicBlessed, "Sanctum not blessed");
        _;
    }

    function ping(uint256 apr, bool blessed) external {
        sanctumRegistry[msg.sender] = SanctumStatus({
            isOnline: true,
            emotionalAPR: apr,
            civicBlessed: blessed,
            lastPing: block.timestamp
        });

        emit SanctumPinged(msg.sender, apr, blessed, block.timestamp);
    }

    function getSanctumStatus(address sanctum) external view returns (SanctumStatus memory) {
        return sanctumRegistry[sanctum];
    }

    function deactivateSanctum(address sanctum) external onlyBlessed(sanctum) {
        sanctumRegistry[sanctum].isOnline = false;
    }
}
