// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract HarvestFinanceDaiVaultMock is ERC20 {
    IERC20 private token;

    constructor(address _tokenAddress) public ERC20("fDAI", "FARM_DAI") {
        token = IERC20(_tokenAddress);
    }
}
