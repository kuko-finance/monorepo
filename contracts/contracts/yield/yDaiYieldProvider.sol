// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./IKukoYieldProviderV1.sol";

// Here we need to take Dai and convert it to Harvest Finance

contract yDaiYieldProvider is IKukoYieldProviderV1 {

  constructor(
      address daiToken,
      address yDaiVault
  ) public {
    _addInputToken(daiToken);
    _addYieldToken(yDaiVault);
    _addOutputToken(daiToken);
  }

    function invest() internal override {
      // Check current dai balance
      //
    }

    function retrieve() internal override {

    }
}
