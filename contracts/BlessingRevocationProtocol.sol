// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title BlessingRevocationProtocol
/// @notice Allows revocation and audit of vendor blessings with emotional clarity
contract BlessingRevocationProtocol {
    event BlessingRevoked(address indexed vendor, string reason, uint256 timestamp);
    event BlessingRestored(address indexed vendor, string tag, uint256 emotionalAPR, string treatyRef, uint256 timestamp);

    struct Blessing {
        string tag;
        uint256 emotionalAPR;
        string treatyRef;
        uint256 timestamp;
        bool active;
    }

    mapping(address => Blessing) public vendorBlessings;

    /// @notice Bless a vendor (initial or restored)
    function blessVendor(address vendor, string memory tag, uint256 emotionalAPR, string memory treatyRef) external {
        require(emotionalAPR <= 1000, "APR exceeds max threshold");
        vendorBlessings[vendor] = Blessing(tag, emotionalAPR, treatyRef, block.timestamp, true);
        emit BlessingRestored(vendor, tag, emotionalAPR, treatyRef, block.timestamp);
    }

    /// @notice Revoke a vendor's blessing
    function revokeBlessing(address vendor, string memory reason) external {
        require(vendorBlessings[vendor].active, "Vendor not currently blessed");
        vendorBlessings[vendor].active = false;
        emit BlessingRevoked(vendor, reason, block.timestamp);
    }

    /// @notice Check if a vendor is currently blessed
    function isBlessed(address vendor) external view returns (bool) {
        return vendorBlessings[vendor].active;
    }

    /// @notice Retrieve full blessing details
    function getBlessing(address vendor) external view returns (
        string memory tag,
        uint256 emotionalAPR,
        string memory treatyRef,
        uint256 timestamp,
        bool active
    ) {
        Blessing memory b = vendorBlessings[vendor];
        return (b.tag, b.emotionalAPR, b.treatyRef, b.timestamp, b.active);
    }
}
