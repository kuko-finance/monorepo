// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface ERC20Mock {
    function generateTokens(address account, uint256 amount) external;
}

contract DaiMock is ERC20("DAI", "DAI"), ERC20Mock {
    function generateTokens(address account, uint256 amount) external override {
        _mint(account, amount);
    }
}
