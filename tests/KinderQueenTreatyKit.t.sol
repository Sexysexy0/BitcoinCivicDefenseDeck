// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/KinderQueenTreatyKit.sol";
import "forge-std/Test.sol";

contract KinderQueenTreatyKitTest is Test {
    KinderQueenTreatyKit kit;

    function setUp() public {
        kit = new KinderQueenTreatyKit();
    }

    function testDeclareTreaty() public {
        kit.declareTreaty("Treaty of Playfulness", "Joy");
        (string memory name, string memory emotion, uint256 ts) = kit.treaties(0);
        assertEq(name, "Treaty of Playfulness");
        assertEq(emotion, "Joy");
        assertGt(ts, 0);
    }

    function testMultipleTreaties() public {
        kit.declareTreaty("Treaty of Kindness", "Empathy");
        kit.declareTreaty("Treaty of Chaos", "Laughter");

        (string memory name, string memory emotion, uint256 ts) = kit.treaties(1);
        assertEq(name, "Treaty of Chaos");
        assertEq(emotion, "Laughter");
        assertGt(ts, 0);
    }
}
