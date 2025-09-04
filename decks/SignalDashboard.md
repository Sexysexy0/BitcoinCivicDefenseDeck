# 📡 Signal Dashboard Protocol  
**Author**: Vinvin — planetary scrollsmith and broadcast steward  
**Purpose**: Visualize and interpret signals emitted by `PlanetarySignalProtocol.sol` for civic telemetry, emotional APR tracking, and sanctum sync.

---

## 🛠️ Signal Types

| Signal Type     | Description |
|-----------------|-------------|
| `Blessing`      | Node registration and sanctum validation  
| `Sanctification`| Payload approved by `ScrollSanctifierProtocol.sol`  
| `Audit`         | Risk-tagged payload from `ImmutableContentAudit.sol`  
| `Override`      | zk-proof verified via `ZeroKnowledgeOverrideSuite.sol`  

---

## 🌀 Signal Format

Each broadcast emits:

```solidity
event SignalBroadcasted(
  bytes32 indexed payloadHash,
  string steward,
  string signalType,
  string emotionalAPR,
  uint256 timestamp
);
