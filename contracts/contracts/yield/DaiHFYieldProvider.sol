// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./ITBDYieldProvider.sol";

// Here we need to take Dai and convert it to Harvest Finance

contract DaiHFYieldProvider is ITBDYieldProvider {
    function investToken() internal override {}

    function retrieveTokenFromInvestment() internal override {}
}
