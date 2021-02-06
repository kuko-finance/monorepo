const DaiMock = artifacts.require("DaiMock");
web3.currentProvider.sendAsync = web3.currentProvider.send;
const {waitUntilBlock} = require('@digix/tempo')(web3);
const KukoEthPriceGamble = artifacts.require('KukoEthPriceGamble');
const createSnapshot = require('../test_utils/createSnapshot');
const revertSnapshot = require('../test_utils/revertSnapshot');

contract('Kuko', async function (accounts) {

  before(async () => {
    this.snap_id = await createSnapshot(web3);
  });

  beforeEach(async () => {
    const status = await revertSnapshot(web3, this.snap_id);
    expect(status).to.be.true;
    this.snap_id = await createSnapshot(web3);
  });

  it('should get accounts', async function() {
    const daiMockInstance = await DaiMock.deployed();
    const amount = '2000000000000000000';
    await daiMockInstance.generateTokens(accounts[0], amount);
    const kukoInstance = await KukoEthPriceGamble.deployed();
    await daiMockInstance.approve(kukoInstance.address, amount);
    await kukoInstance.deposit(1, '900000000000000000');
    const shares = await kukoInstance.sharesOf(accounts[0]);
    const sharesOfOption1 = await kukoInstance.balanceOf(accounts[0], 1);
    const waitUntil = parseInt((await kukoInstance.startBlock()).add(await kukoInstance.fundingPhaseBlockLength()).toString());
    console.log(await web3.eth.getBlockNumber())
    await waitUntilBlock(20, waitUntil);
    console.log(await web3.eth.getBlockNumber())
    console.log('pre-start', (await daiMockInstance.balanceOf(kukoInstance.address)).toString());
    await kukoInstance.start();
    console.log('start', (await daiMockInstance.balanceOf(kukoInstance.address)).toString());
    await waitUntilBlock(20, 160);
    await kukoInstance.deposit(0, '1000000000000000000');
    const sharesOfOption0 = await kukoInstance.balanceOf(accounts[0], 0);
    console.log(shares.toString());
    console.log(sharesOfOption1.toString());
    console.log(sharesOfOption0.toString());
  })

});
