const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ZeroKnowledgeOverrideSuite", function () {
  let ZKSuite;
  let steward;

  beforeEach(async function () {
    const ZKFactory = await ethers.getContractFactory("ZeroKnowledgeOverrideSuite");
    ZKSuite = await ZKFactory.deploy();
    await ZKSuite.deployed();

    [steward] = await ethers.getSigners();
  });

  it("should accept a valid zk-proof and bless the payload", async function () {
    const payload = ethers.utils.toUtf8Bytes("Treaty-grade payload");
    const hash = ethers.utils.keccak256(payload);
    const emotionalAPR = "High Mercy";

    const tx = await ZKSuite.submitProof(hash, true, "Vinvin", emotionalAPR);
    const receipt = await tx.wait();

    const proof = await ZKSuite.getProof(hash);
    expect(proof.isValid).to.be.true;
    expect(proof.steward).to.equal("Vinvin");
    expect(proof.emotionalAPR).to.equal(emotionalAPR);
    expect(proof.timestamp).to.be.gt(0);
  });

  it("should reject duplicate zk-proof submissions", async function () {
    const payload = ethers.utils.toUtf8Bytes("Scroll of Mercy");
    const hash = ethers.utils.keccak256(payload);

    await ZKSuite.submitProof(hash, true, "Vinvin", "Damay Confirmed");

    await expect(
      ZKSuite.submitProof(hash, true, "Vinvin", "Damay Confirmed")
    ).to.be.revertedWith("Proof already submitted");
  });

  it("should confirm treaty-grade status of a payload", async function () {
    const payload = ethers.utils.toUtf8Bytes("Blessed Payload");
    const hash = ethers.utils.keccak256(payload);

    await ZKSuite.submitProof(hash, true, "Vinvin", "High Mercy");
    const isTreatyGrade = await ZKSuite.isTreatyGrade(hash);

    expect(isTreatyGrade).to.be.true;
  });
});
