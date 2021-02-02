// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract yDaiVaultMock is ERC20 {
    IERC20 private token;

    constructor(address _tokenAddress) public ERC20("yDAI", "yearn Dai Mock") {
        token = IERC20(_tokenAddress);
    }

    function deposit(uint256 _amount) public {

    }

    function withdraw(uint256 _amount) public {

    }
}
