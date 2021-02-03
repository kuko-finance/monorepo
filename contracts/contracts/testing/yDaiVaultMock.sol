// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract yDaiVaultMock is ERC20 {
    IERC20 private token;
    uint256 private initBlock = block.number;

    constructor(address _tokenAddress) public ERC20("yDAI", "yearn Dai Mock") {
        token = IERC20(_tokenAddress);
    }

    function deposit(uint256 _amount) public {
        // ERC20 transfer towards this contract
        //
    }

    function withdraw(uint256 _amount) public {}

    // https://etherscan.io/token/0x16de59092dae5ccf4a1e6439d611fd0653f0bd01#readContract this to get amount of dai etc
}
