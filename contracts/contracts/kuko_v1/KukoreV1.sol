// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

abstract contract KukoreV1 {

    function _onStart() internal virtual;

    function _onClose() internal virtual;

    function deposit(uint256 amount) public virtual;

    function withdraw(uint256 amount) public virtual;

}

