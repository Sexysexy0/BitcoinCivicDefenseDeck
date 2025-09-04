const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ScrollSanctifierProtocol", function () {
  let Sanctifier;
  let steward;

  beforeEach(async function () {
    const SanctifierFactory = await ethers.getContractFactory("ScrollSanctifierProtocol");
    Sanctifier = await SanctifierFactory.deploy();
    await Sanctifier.deployed();

    [steward] = await ethers.getSigners();
  });

  it("should bless a treaty-grade payload", async function () {
    const payload = ethers.utils.toUtf8Bytes("Barangay Treaty Scroll");
    const stewardName = "Vinvin";
    const emotionalAPR = "High Mercy";
    const damayClause = true;

    const tx = await Sanctifier.blessPayload(payload, stewardName, emotionalAPR, damayClause);
    const receipt = await tx.wait();

    const hash = ethers.utils.keccak256(payload);
    const blessed = await Sanctifier.getSanctified(hash);

    expect(blessed.steward).to.equal(stewardName);
    expect(blessed.emotionalAPR).to.equal(emotionalAPR);
    expect(blessed.damayClause).to.equal(damayClause);
    expect(blessed.timestamp).to.be.gt(0);
  });

  it("should reject duplicate blessings", async function () {
    const payload = ethers.utils.toUtf8Bytes("Scroll of Mercy");
    await Sanctifier.blessPayload(payload, "Vinvin", "Damay Confirmed", true);

    await expect(
      Sanctifier.blessPayload(payload, "Vinvin", "Damay Confirmed", true)
    ).to.be.revertedWith("Payload already sanctified");
  });

  it("should confirm if a payload is blessed", async function () {
    const payload = ethers.utils.toUtf8Bytes("Emotional APR Scroll");
    const hash = ethers.utils.keccak256(payload);

    await Sanctifier.blessPayload(payload, "Vinvin", "High Mercy", true);
    const isBlessed = await Sanctifier.isBlessed(hash);

    expect(isBlessed).to.be.true;
  });
});
