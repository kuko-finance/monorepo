// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./DaiMock.sol";

contract YDaiVaultMock is ERC20 {
    using SafeERC20 for IERC20;

    IERC20 private token;
    uint256 private initBlock = block.number;

    constructor(address _tokenAddress) public ERC20("yDAI", "yearn Dai Mock") {
        token = IERC20(_tokenAddress);
    }

    function deposit(uint256 _amount) public {
        uint256 amountToMint = _amount / getPricePerFullShare();
        _mint(msg.sender, amountToMint);
        token.safeTransferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint256 _amount) public {
        uint256 amountToWithdraw = _amount * getPricePerFullShare();
        uint256 contractBalance = token.balanceOf(address(this));

        if (contractBalance < amountToWithdraw) {
            uint256 amountToMint = amountToWithdraw - contractBalance;
            ERC20Mock(address(token)).generateTokens(address(this), amountToMint);
        }

        token.safeTransfer(msg.sender, amountToWithdraw);
    }

    function getPricePerFullShare() public view returns (uint256) {
        return 1062625073495028852 + (100000000000000 * (block.number - initBlock));
    }

    // https://etherscan.io/token/0x16de59092dae5ccf4a1e6439d611fd0653f0bd01#readContract this to get amount of dai etc
}
