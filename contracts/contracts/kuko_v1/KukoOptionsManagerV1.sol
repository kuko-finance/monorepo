// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

import "./KukoOptionsV1.sol";

abstract contract KukoOptionsManagerV1 {
    function _initialize(uint256 optionCount) internal virtual returns (KukoOptionV1[] memory);

    function _isManager(uint256 id) internal view virtual returns (bool);

    function _resolve(KukoOptionV1 memory option) internal virtual returns (int8);
}
