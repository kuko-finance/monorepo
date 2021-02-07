// SPDX-License-Identifier: MIT
//   ___  __    ___  ___  ___  __    ________
//  |\  \|\  \ |\  \|\  \|\  \|\  \ |\   __  \
//  \ \  \/  /|\ \  \\\  \ \  \/  /|\ \  \|\  \
//   \ \   ___  \ \  \\\  \ \   ___  \ \  \\\  \
//    \ \  \\ \  \ \  \\\  \ \  \\ \  \ \  \\\  \
//     \ \__\\ \__\ \_______\ \__\\ \__\ \_______\
//      \|__| \|__|\|_______|\|__| \|__|\|_______|
//
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";

abstract contract KukoreV1 is IERC1155Upgradeable {
    function _onStart() internal virtual;

    function _onClose() internal virtual;

    function start() public virtual;

    function close() public virtual;

    function cancel() public virtual;

    function deposit(uint256 option, uint256 amount) public virtual;

    function withdraw(uint256 option, uint256 amount) public virtual;

    function withdrawDeposit(uint256 amount) public virtual;

    function withdrawBatch(uint256[] memory options, bool withDeposit) public virtual;

    function totalDeposit() external view virtual returns (uint256);

    function totalFunds() external view virtual returns (uint256);

    function totalShares() external view virtual returns (uint256);

    function depositOf(address owner) external view virtual returns (uint256);

    function sharesOf(address owner) external view virtual returns (uint256);
}
