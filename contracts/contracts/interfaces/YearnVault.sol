// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

abstract contract YearnVault is ERC20 {
    function deposit(uint256 _amount) public virtual;

    function withdraw(uint256 _amount) public virtual;

    function getPricePerFullShare() public view virtual returns (uint256);
}
