const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NodeLiabilityShield", function () {
  let ShieldContract;
  let steward;

  beforeEach(async function () {
    const ShieldFactory = await ethers.getContractFactory("NodeLiabilityShield");
    ShieldContract = await ShieldFactory.deploy();
    await ShieldContract.deployed();

    [steward] = await ethers.getSigners();
  });

  it("should register a node and emit a blessing", async function () {
    const sanctumName = "Northville 8";
    const jurisdiction = "PH-Central Luzon";
    const emotionalAPR = "Damay Confirmed";

    const tx = await ShieldContract.registerNode(sanctumName, jurisdiction, emotionalAPR);
    const receipt = await tx.wait();

    const blessing = await ShieldContract.getBlessing(steward.address);

    expect(blessing.sanctumName).to.equal(sanctumName);
    expect(blessing.jurisdiction).to.equal(jurisdiction);
    expect(blessing.emotionalAPR).to.equal(emotionalAPR);
    expect(blessing.timestamp).to.be.gt(0);
  });

  it("should verify that a node is blessed", async function () {
    await ShieldContract.registerNode("Bangkal Sanctum", "PH-Central Luzon", "High Mercy");
    const isBlessed = await ShieldContract.isBlessed(steward.address);
    expect(isBlessed).to.be.true;
  });

  it("should return false for unregistered nodes", async function () {
    const [, rogue] = await ethers.getSigners();
    const isBlessed = await ShieldContract.isBlessed(rogue.address);
    expect(isBlessed).to.be.false;
  });
});
