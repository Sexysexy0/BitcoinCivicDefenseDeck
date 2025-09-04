// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/BlessingAppealProtocol.sol";
import "forge-std/Test.sol";

contract BlessingAppealAudit is Test {
    BlessingAppealProtocol appeal;

    function setUp() public {
        appeal = new BlessingAppealProtocol();
    }

    function testSubmitAppeal() public {
        appeal.submitAppeal(address(0xBEEF), "We were misinterpreted. Treaty still honored.");
        (string memory justification, bool resolved, , , uint256 ts) = appeal.getAppeal(address(0xBEEF));
        assertEq(justification, "We were misinterpreted. Treaty still honored.");
        assertFalse(resolved);
        assertGt(ts, 0);
    }

    function testResolveAppealApproved() public {
        appeal.submitAppeal(address(0xCAFE), "Emotional APR recalibrated. Ready to restore.");
        appeal.resolveAppeal(address(0xCAFE), true, "Blessing reinstated after audit.");
        (, bool resolved, bool approved, string memory note, ) = appeal.getAppeal(address(0xCAFE));
        assertTrue(resolved);
        assertTrue(approved);
        assertEq(note, "Blessing reinstated after audit.");
    }

    function testResolveAppealRejected() public {
        appeal.submitAppeal(address(0xDEAD), "No treaty breach occurred.");
        appeal.resolveAppeal(address(0xDEAD), false, "Evidence insufficient. Blessing remains revoked.");
        (, bool resolved, bool approved, string memory note, ) = appeal.getAppeal(address(0xDEAD));
        assertTrue(resolved);
        assertFalse(approved);
        assertEq(note, "Evidence insufficient. Blessing remains revoked.");
    }

    function testDoubleResolutionFails() public {
        appeal.submitAppeal(address(0xFEED), "We request mercy and re-certification.");
        appeal.resolveAppeal(address(0xFEED), true, "Blessing restored.");
        vm.expectRevert("Appeal already resolved");
        appeal.resolveAppeal(address(0xFEED), false, "Second attempt blocked.");
    }
}
