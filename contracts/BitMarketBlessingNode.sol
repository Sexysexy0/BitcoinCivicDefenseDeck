// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title BitMarketBlessingNode
/// @notice Tags vendors with emotional resonance and treaty-grade blessings
contract BitMarketBlessingNode {
    event VendorBlessed(
        address indexed vendor,
        string blessingTag,
        uint256 emotionalAPR,
        uint256 timestamp
    );

    struct Blessing {
        string tag;
        uint256 emotionalAPR; // Basis points (0–1000)
        uint256 timestamp;
    }

    mapping(address => Blessing) public vendorBlessings;

    /// @notice Bless a vendor with a tag and emotional APR
    /// @param vendor Address of the vendor
    /// @param tag Mythic blessing tag (e.g. "KinderQueen", "BarangayCertified")
    /// @param emotionalAPR Emotional resonance score (0–1000 basis points)
    function blessVendor(address vendor, string memory tag, uint256 emotionalAPR) external {
        require(emotionalAPR <= 1000, "APR exceeds max threshold");
        vendorBlessings[vendor] = Blessing(tag, emotionalAPR, block.timestamp);
        emit VendorBlessed(vendor, tag, emotionalAPR, block.timestamp);
    }

    /// @notice Retrieve blessing details for a vendor
    /// @param vendor Address of the vendor
    /// @return tag, emotionalAPR, timestamp
    function getBlessing(address vendor) external view returns (string memory, uint256, uint256) {
        Blessing memory b = vendorBlessings[vendor];
        return (b.tag, b.emotionalAPR, b.timestamp);
    }

    /// @notice Check if a vendor is blessed
    /// @param vendor Address of the vendor
    /// @return true if blessed, false otherwise
    function isBlessed(address vendor) external view returns (bool) {
        return vendorBlessings[vendor].timestamp != 0;
    }
}
