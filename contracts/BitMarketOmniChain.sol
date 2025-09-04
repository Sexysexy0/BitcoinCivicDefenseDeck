// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./BlessingRevocationProtocol.sol";

contract BitMarketOmniChain {
    BlessingRevocationProtocol public revocation;

    constructor(address revocationAddress) {
        revocation = BlessingRevocationProtocol(revocationAddress);
    }

    function isVendorActive(address vendor) public view returns (bool) {
        return revocation.isBlessed(vendor);
    }

    function getVendorBlessing(address vendor) public view returns (
        string memory tag,
        uint256 emotionalAPR,
        string memory treatyRef,
        uint256 timestamp,
        bool active
    ) {
        return revocation.getBlessing(vendor);
    }
}
