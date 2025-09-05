// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

contract DLLSideLoadScanner {
    struct InjectionLog {
        string executable;
        string dllInjected;
        bool isTrusted;
        uint256 timestamp;
    }

    mapping(address => InjectionLog[]) public scanLog;
    event InjectionDetected(address indexed device, string executable, string dllInjected, bool isTrusted, uint256 timestamp);

    function logInjection(address device, string calldata exe, string calldata dll, bool trusted) external {
        scanLog[device].push(InjectionLog(exe, dll, trusted, block.timestamp));
        emit InjectionDetected(device, exe, dll, trusted, block.timestamp);
    }

    function getLatestInjection(address device) external view returns (InjectionLog memory) {
        uint256 len = scanLog[device].length;
        require(len > 0, "No injection recorded");
        return scanLog[device][len - 1];
    }
}
