const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ImmutableContentAudit", function () {
  let AuditContract;

  beforeEach(async function () {
    const AuditFactory = await ethers.getContractFactory("ImmutableContentAudit");
    AuditContract = await AuditFactory.deploy();
    await AuditContract.deployed();
  });

  it("should tag a benign payload as Blessed", async function () {
    const payload = ethers.utils.toUtf8Bytes("Treaty-grade civic scroll");
    const emotionalAPR = "High Mercy";

    const tx = await AuditContract.submitPayload(payload, emotionalAPR);
    const receipt = await tx.wait();

    const hash = ethers.utils.keccak256(payload);
    const audit = await AuditContract.getAudit(hash);

    expect(audit.risk).to.equal(0); // Blessed
    expect(audit.emotionalAPR).to.equal(emotionalAPR);
    expect(audit.timestamp).to.be.gt(0);
  });

  it("should tag a suspicious payload as Illicit", async function () {
    const payload = ethers.utils.hexlify([0xDE, 0xAD, 0xBE, 0xEF, 0x01]);
    const emotionalAPR = "Suspicious";

    const tx = await AuditContract.submitPayload(payload, emotionalAPR);
    const receipt = await tx.wait();

    const hash = ethers.utils.keccak256(payload);
    const audit = await AuditContract.getAudit(hash);

    expect(audit.risk).to.equal(2); // Illicit
    expect(audit.emotionalAPR).to.equal(emotionalAPR);
  });

  it("should reject duplicate payloads", async function () {
    const payload = ethers.utils.toUtf8Bytes("Scroll of Mercy");
    const emotionalAPR = "Damay Confirmed";

    await AuditContract.submitPayload(payload, emotionalAPR);
    await expect(
      AuditContract.submitPayload(payload, emotionalAPR)
    ).to.be.revertedWith("Payload already audited");
  });
});
