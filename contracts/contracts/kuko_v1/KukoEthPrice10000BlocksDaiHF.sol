// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

import "../yield/DaiHFYieldProvider.sol";
import "./KukoV1.sol";

contract KukoEthPrice10000BlocksDaiHF is DaiHFYieldProvider, KukoV1 {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    ///@notice Hi test
    ///@param name Name of the contract
    constructor(string memory name, address inputToken)
        public
        KukoV1(
            name,
            msg.sender,
            msg.sender,
            20000,
            3300,
            3300,
            3300,
            20000, // 3 days
            200000, // 30 days
            180000, // 90% of period
            200000
        )
    {
        token = IERC20(inputToken);

        options.push(
            KukoOptionV1({
                id: 0,
                name: "Above",
                description: "The price of ETH will be above Key Value",
                keyValue: 1,
                finalized: 0,
                shares: 0
            })
        );

        optionIds[0] = 0;

        options.push(
            KukoOptionV1({
                id: 1,
                name: "Under",
                description: "The price of ETH will be under Key Value",
                keyValue: 1,
                finalized: 0,
                shares: 0
            })
        );

        optionIds[1] = 1;

    }

    function _onStart() internal override {

    }

    function _onClose() internal override {

    }

    function deposit(uint256 amount) public override {

    }

    function withdraw(uint256 amount) public override {

    }

    // How to you list outputs in a generic manner
}
