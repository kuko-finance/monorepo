// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "../kuko_v1/KukoYieldManagerV1.sol";

// Here we need to take Dai and convert it to Harvest Finance

contract yDaiYieldProvider is KukoYieldManagerV1 {
    constructor(address daiToken, address yDaiVault) public {
        _setInputToken(daiToken);
        _addYieldToken(yDaiVault);
        _addOutputToken(daiToken);
    }

    function _invest() internal override {
        // Check current dai balance and invest all
        //
    }

    function _retrieve() internal override {}

    function _totalFunds() internal override returns (uint256) {}
}
