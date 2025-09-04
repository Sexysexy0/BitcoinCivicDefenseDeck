// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VendorBlessingProtocol {
    event VendorOnboarded(address indexed vendor, string tag, uint256 apr, string treatyRef, uint256 timestamp);

    struct Vendor {
        string tag;
        uint256 emotionalAPR;
        string treatyRef;
        uint256 timestamp;
    }

    mapping(address => Vendor) public vendors;

    function onboardVendor(address vendor, string memory tag, uint256 apr, string memory treatyRef) external {
        require(apr <= 1000, "APR exceeds max threshold");
        vendors[vendor] = Vendor(tag, apr, treatyRef, block.timestamp);
        emit VendorOnboarded(vendor, tag, apr, treatyRef, block.timestamp);
    }

    function getVendor(address vendor) external view returns (string memory, uint256, string memory, uint256) {
        Vendor memory v = vendors[vendor];
        return (v.tag, v.emotionalAPR, v.treatyRef, v.timestamp);
    }
}
