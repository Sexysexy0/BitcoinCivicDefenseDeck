// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

contract APT28LockdownProtocol {
    struct DeviceLog {
        string cpuID;
        string macAddress;
        string operationType;
        bool lockdownActive;
        uint256 timestamp;
    }

    mapping(address => DeviceLog[]) public lockdownRegistry;
    event LockdownTriggered(address indexed device, string cpuID, string operationType, uint256 timestamp);

    function triggerLockdown(address device, string calldata cpuID, string calldata mac, string calldata opType) external {
        lockdownRegistry[device].push(DeviceLog(cpuID, mac, opType, true, block.timestamp));
        emit LockdownTriggered(device, cpuID, opType, block.timestamp);
    }

    function isLocked(address device) external view returns (bool) {
        uint256 len = lockdownRegistry[device].length;
        if (len == 0) return false;
        return lockdownRegistry[device][len - 1].lockdownActive;
    }

    function getLatestLog(address device) external view returns (DeviceLog memory) {
        uint256 len = lockdownRegistry[device].length;
        require(len > 0, "No logs found");
        return lockdownRegistry[device][len - 1];
    }
}
