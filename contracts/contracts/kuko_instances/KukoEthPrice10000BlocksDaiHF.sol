// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

import "../yield/yDaiYieldProvider.sol";
import "../kuko_v1/KukoV1.sol";

contract KukoEthPrice10000BlocksDaiHF is yDaiYieldProvider, KukoV1 {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    ///@notice Hi test
    ///@param name Name of the contract
    constructor(
      string memory name,
      address inputToken,
      address vaultAddress
      )
        public
        yDaiYieldProvider(
          inputToken,
          vaultAddress
        )
        KukoV1(
          "https://uri.com"
        )
    {
        _setName(name);

        _setOwner(msg.sender);
        _setLauncher(msg.sender);

        _setOwnerShare(20000);
        _setLauncherShare(3300);
        _setRunnerShare(3300);
        _setCloserShare(3300);
        _setLoserShare(200000);

        _setFundingPhaseBlockLength(20000);
        _setRunningPhaseBlockLength(200000);
        _setPostFundingPhaseBlockLength(180000);

        _setToken(inputToken);

    }

    function _onStart() internal override {

    }

    function _onClose() internal override {

    }

    function deposit(uint256 amount) public override {

    }

    function withdraw(uint256 amount) public override {

    }

    // How to you list outputs in a generic manner
}
