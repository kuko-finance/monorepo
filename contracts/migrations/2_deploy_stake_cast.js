const DAIMock = artifacts.require('DAIMock');
const yDaiVaultMock = artifacts.require('yDaiVaultMock');
const UniswapETHDAIPoolMock = artifacts.require('UniswapETHDAIPoolMock');
const KukoEthPriceGamble = artifacts.require('KukoEthPriceGamble');
const KuiriLeague = artifacts.require('KuiriLeagueV1');

module.exports = function (deployer, net) {
  deployer.then(async () => {

    switch (net) {
      case 'goerli':
      case 'test':
      case 'ganache': {
        const DaiMockInstance = await deployer.deploy(DAIMock);
        const yDaiVaultMockInstance = await deployer.deploy(yDaiVaultMock, DaiMockInstance.address);
        const UniswapEthDaiPoolMockInstance = await deployer.deploy(UniswapETHDAIPoolMock);
        const KukoEthPriceGambleInstance = await deployer.deploy(KukoEthPriceGamble);
        await KukoEthPriceGambleInstance.__KukoEthPriceGamble__init('Kuko', DaiMockInstance.address, yDaiVaultMockInstance.address, UniswapEthDaiPoolMockInstance.address, 20, 200, 180);
        const KuiriLeagueInstance = await deployer.deploy(KuiriLeague);
        await KuiriLeagueInstance.__KuiriLeagueV1__init();

        break;
      }
      default: {
        break ;
      }
    }

  });
};
