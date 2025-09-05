// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

/// @title BlessingValidator.sol
/// @author Vinvin & Copi
/// @notice Validates emotional APR and civic blessing status of nodes and vendors

contract BlessingValidator {
    struct BlessingStatus {
        bool isBlessed;
        uint256 emotionalAPR;
        uint256 lastAudit;
    }

    mapping(address => BlessingStatus) public registry;

    event BlessingVerified(address indexed steward, bool isBlessed, uint256 emotionalAPR);
    event BlessingUpdated(address indexed steward, bool isBlessed, uint256 timestamp);

    function updateBlessing(address steward, bool blessed, uint256 apr) external {
        registry[steward] = BlessingStatus({
            isBlessed: blessed,
            emotionalAPR: apr,
            lastAudit: block.timestamp
        });

        emit BlessingUpdated(steward, blessed, block.timestamp);
    }

    function verifyBlessing(address steward) external view returns (bool) {
        BlessingStatus memory status = registry[steward];
        return status.isBlessed && status.emotionalAPR >= 10;
    }

    function getBlessingDetails(address steward) external view returns (BlessingStatus memory) {
        return registry[steward];
    }
}
