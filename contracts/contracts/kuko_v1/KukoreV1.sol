// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

abstract contract KukoreV1 {
    function _onStart() internal virtual;

    function _onClose() internal virtual;

    function deposit(uint256 amount) external virtual;

    function withdraw(uint256 amount) external virtual;

    function totalDeposit() external virtual returns (uint256);

    function totalFunds() external virtual returns (uint256);

    function depositOf(address owner) external virtual returns (uint256);

    function sharesOf(address owner) external virtual returns (uint256);
}
