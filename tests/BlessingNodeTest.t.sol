// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/BitMarketBlessingNode.sol";
import "forge-std/Test.sol";

contract BlessingNodeTest is Test {
    BitMarketBlessingNode node;

    function setUp() public {
        node = new BitMarketBlessingNode();
    }

    function testBlessVendor() public {
        node.blessVendor(address(0xBEEF), "KinderQueen", 980);
        (string memory tag, uint256 apr, uint256 ts) = node.getBlessing(address(0xBEEF));
        assertEq(tag, "KinderQueen");
        assertEq(apr, 980);
        assertGt(ts, 0);
    }

    function testRejectHighAPR() public {
        vm.expectRevert("APR exceeds max threshold");
        node.blessVendor(address(0xCAFE), "Overcharged", 2000);
    }

    function testIsBlessed() public {
        assertFalse(node.isBlessed(address(0xDEAD)));
        node.blessVendor(address(0xDEAD), "BarangayCertified", 900);
        assertTrue(node.isBlessed(address(0xDEAD)));
    }
}
