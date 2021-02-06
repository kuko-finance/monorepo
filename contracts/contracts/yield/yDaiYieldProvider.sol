// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "../kuko_v1/KukoYieldManagerV1.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "../interfaces/YearnVault.sol";

// Here we need to take Dai and convert it to Harvest Finance

abstract contract YDaiYieldProvider is KukoYieldManagerV1, Initializable {
    using SafeERC20 for IERC20;

    YearnVault private vault;
    IERC20 private token;

    // solhint-disable-next-line
    function __YDaiYieldProvider__init(address daiToken, address yDaiVault) internal initializer {
        _setInputToken(daiToken);
        _addYieldToken(yDaiVault);
        _addOutputToken(daiToken);

        vault = YearnVault(yDaiVault);
        token = IERC20(daiToken);
    }

    function _invest() internal override {
        uint256 currentDaiBalance = token.balanceOf(address(this));
        token.safeApprove(address(vault), currentDaiBalance);
        vault.deposit(currentDaiBalance);
    }

    function _retrieve() internal override {
        uint256 currentShareBalance = vault.balanceOf(address(this));
        vault.withdraw(currentShareBalance);
    }

    function _totalFunds() internal view override returns (uint256) {
        return vault.balanceOf(address(this)) * vault.getPricePerFullShare();
    }
}
