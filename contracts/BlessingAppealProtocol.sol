// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title BlessingAppealProtocol
/// @notice Allows vendors to appeal revoked blessings with emotional justification
contract BlessingAppealProtocol {
    event AppealSubmitted(address indexed vendor, string justification, uint256 timestamp);
    event AppealResolved(address indexed vendor, bool approved, string resolutionNote, uint256 timestamp);

    struct Appeal {
        string justification;
        bool resolved;
        bool approved;
        string resolutionNote;
        uint256 timestamp;
    }

    mapping(address => Appeal) public appeals;

    function submitAppeal(address vendor, string memory justification) external {
        require(bytes(justification).length > 0, "Justification required");
        appeals[vendor] = Appeal(justification, false, false, "", block.timestamp);
        emit AppealSubmitted(vendor, justification, block.timestamp);
    }

    function resolveAppeal(address vendor, bool approve, string memory note) external {
        require(!appeals[vendor].resolved, "Appeal already resolved");
        appeals[vendor].resolved = true;
        appeals[vendor].approved = approve;
        appeals[vendor].resolutionNote = note;
        emit AppealResolved(vendor, approve, note, block.timestamp);
    }

    function getAppeal(address vendor) external view returns (
        string memory justification,
        bool resolved,
        bool approved,
        string memory resolutionNote,
        uint256 timestamp
    ) {
        Appeal memory a = appeals[vendor];
        return (a.justification, a.resolved, a.approved, a.resolutionNote, a.timestamp);
    }
}
