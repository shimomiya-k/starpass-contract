import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Social", function () {
  async function deploy() {
    const [owner, otherAccount] = await ethers.getSigners();
    const Social = await ethers.getContractFactory("Social");
    const social = await Social.deploy();
    return { social, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Owner", async function () {
      const { social, owner, otherAccount } = await loadFixture(deploy);
      const ownerAddress = await social.owner();
      expect(ownerAddress).to.equal(owner.address);
    });
  });

  describe("Message", function () {
    // 投稿のテスト
    it("Post", async function () {
      const { social, owner, otherAccount } = await loadFixture(deploy);
      var messages = await social.getAllMessages();
      expect(messages.length).to.equal(0);

      await social.postMessage("test");

      var messages = await social.getAllMessages();
      expect(messages.length).to.equal(1);
      expect(messages[0].owner).to.equal(owner.address);
      expect(messages[0].text).to.equal("test");

      await social.connect(otherAccount).postMessage("otherAccount");
      var messages = await social.getAllMessages();
      expect(messages.length).to.equal(2);
      expect(messages[1].owner).to.equal(otherAccount.address);
      expect(messages[1].text).to.equal("otherAccount");
    });
  });
});
