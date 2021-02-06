const DAIMock = artifacts.require('DAIMock');
const yDaiVaultMock = artifacts.require('yDaiVaultMock');
const UniswapETHDAIPoolMock = artifacts.require('UniswapETHDAIPoolMock');
const KukoEthPriceGamble = artifacts.require('KukoEthPriceGamble');

module.exports = function (deployer, net) {
  deployer.then(async () => {

    switch (net) {
      case 'test': {
        const DaiMockInstance = await deployer.deploy(DAIMock);
        const yDaiVaultMockInstance = await deployer.deploy(yDaiVaultMock, DaiMockInstance.address);
        const UniswapEthDaiPoolMockInstance = await deployer.deploy(UniswapETHDAIPoolMock);
        const KukoEthPriceGambleInstance = await deployer.deploy(KukoEthPriceGamble);
        KukoEthPriceGambleInstance.__KukoEthPriceGamble__init('Kuko', DaiMockInstance.address, yDaiVaultMockInstance.address, UniswapEthDaiPoolMockInstance.address, 20, 200, 180);

        break;
      }
      case 'ganache': {
        const DaiMockInstance = await deployer.deploy(DAIMock);
        const yDaiVaultMockInstance = await deployer.deploy(yDaiVaultMock, DaiMockInstance.address);
        const UniswapEthDaiPoolMockInstance = await deployer.deploy(UniswapETHDAIPoolMock);
        const KukoEthPriceGambleInstance = await deployer.deploy(KukoEthPriceGamble);
        // KukoEthPriceGambleInstance.__KukoEthPriceGamble__init('Kuko', DaiMockInstance.address, yDaiVaultMockInstance.address, UniswapEthDaiPoolMockInstance.address, 20, 200, 180);

        break;
      }
      default: {
      }
    }

  });
};
