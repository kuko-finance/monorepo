const DAIMock = artifacts.require('DAIMock');

module.exports = function (deployer, net) {
  deployer.then(async () => {

    switch (net) {
      case 'test': {
        const DaiMockInstance = await deployer.deploy(DAIMock);

        break;
      }
      case 'ganache': {
        const DaiMockInstance = await deployer.deploy(DAIMock);

        break;
      }
      default: {
      }
    }

  });
};
