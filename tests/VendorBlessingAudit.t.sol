// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/VendorBlessingProtocol.sol";
import "forge-std/Test.sol";

contract VendorBlessingAudit is Test {
    VendorBlessingProtocol protocol;

    function setUp() public {
        protocol = new VendorBlessingProtocol();
    }

    function testOnboardVendor() public {
        protocol.onboardVendor(address(0xBEEF), "KinderQueen", 980, "Treaty of Playfulness");
        (string memory tag, uint256 apr, string memory treaty, uint256 ts) = protocol.getVendor(address(0xBEEF));
        assertEq(tag, "KinderQueen");
        assertEq(apr, 980);
        assertEq(treaty, "Treaty of Playfulness");
        assertGt(ts, 0);
    }

    function testRejectHighAPR() public {
        vm.expectRevert("APR exceeds max threshold");
        protocol.onboardVendor(address(0xCAFE), "Overcharged", 2001, "Treaty of Chaos");
    }

    function testMultipleVendors() public {
        protocol.onboardVendor(address(0xDEAD), "BarangayCertified", 900, "Treaty of Kindness");
        protocol.onboardVendor(address(0xFEED), "KinderQueen", 950, "Treaty of Joy");

        (, uint256 apr1,,) = protocol.getVendor(address(0xDEAD));
        (, uint256 apr2,,) = protocol.getVendor(address(0xFEED));

        assertEq(apr1, 900);
        assertEq(apr2, 950);
    }
}
