// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/BlessingRevocationProtocol.sol";
import "forge-std/Test.sol";

contract BlessingRevocationAudit is Test {
    BlessingRevocationProtocol protocol;

    function setUp() public {
        protocol = new BlessingRevocationProtocol();
    }

    function testBlessVendor() public {
        protocol.blessVendor(address(0xBEEF), "KinderQueen", 980, "Treaty of Playfulness");
        (string memory tag, uint256 apr, string memory treaty, uint256 ts, bool active) = protocol.getBlessing(address(0xBEEF));
        assertEq(tag, "KinderQueen");
        assertEq(apr, 980);
        assertEq(treaty, "Treaty of Playfulness");
        assertGt(ts, 0);
        assertTrue(active);
    }

    function testRevokeBlessing() public {
        protocol.blessVendor(address(0xCAFE), "BarangayCertified", 900, "Treaty of Kindness");
        protocol.revokeBlessing(address(0xCAFE), "Violation of treaty terms");
        (, , , , bool active) = protocol.getBlessing(address(0xCAFE));
        assertFalse(active);
    }

    function testDoubleRevokeFails() public {
        protocol.blessVendor(address(0xDEAD), "KinderQueen", 950, "Treaty of Joy");
        protocol.revokeBlessing(address(0xDEAD), "Initial audit failure");

        vm.expectRevert("Vendor not currently blessed");
        protocol.revokeBlessing(address(0xDEAD), "Second attempt");
    }

    function testRestoreBlessing() public {
        protocol.blessVendor(address(0xFEED), "KinderQueen", 920, "Treaty of Mercy");
        protocol.revokeBlessing(address(0xFEED), "Temporary suspension");

        protocol.blessVendor(address(0xFEED), "KinderQueen", 925, "Treaty of Restoration");
        (, uint256 apr, string memory treaty, , bool active) = protocol.getBlessing(address(0xFEED));
        assertEq(apr, 925);
        assertEq(treaty, "Treaty of Restoration");
        assertTrue(active);
    }
}
