const TBD = artifacts.require("TBDEthPrice10000BlocksDaiHF");
const DAIMock = artifacts.require("DAIMock");

module.exports = function (deployer, net) {
  deployer.then(async () => {
    const DaiMockInstance = await deployer.deploy(DAIMock);
    await deployer.deploy(TBD, "Test", DaiMockInstance.address);
  });
};
