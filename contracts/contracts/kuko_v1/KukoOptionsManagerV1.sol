// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

import "./KukoV1.sol";

abstract contract KukoOptionsManagerV1 {
    function initialize(uint256 optionCount)
        internal
        virtual
        returns (KukoOptionV1[] memory);

    function getOptionIds() internal virtual returns (uint256[] memory);

    function resolve(KukoOptionV1 memory option)
        internal
        virtual
        returns (int8);
}
