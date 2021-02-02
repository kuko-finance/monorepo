// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DAIMock is ERC20("DAI", "DAI") {
    function generateTokens(address account, uint256 amount) public {
        _mint(account, amount);
    }
}
