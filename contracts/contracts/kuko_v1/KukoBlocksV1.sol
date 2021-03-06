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

import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";

abstract contract KukoBlocksV1 is Initializable {
    uint256 public startBlock;
    uint256 public runBlock;
    uint256 public fundingPhaseBlockLength;
    uint256 public runningPhaseBlockLength;
    uint256 public postFundingPhaseBlockLength;

    // solhint-disable-next-line
    function __KukoBlocksV1__init() internal initializer {
        startBlock = block.number;
    }

    modifier isClosable() {
        require(block.number >= runBlock + runningPhaseBlockLength, "cannot_close_contract");
        _;
    }

    modifier isDepositable() {
        require(block.number < runBlock + postFundingPhaseBlockLength, "cannot_fund_contract");
        _;
    }

    function _captureRunBlock() internal {
        runBlock = block.number;
    }

    function _setFundingPhaseBlockLength(uint256 _fundingPhaseBlockLength) internal {
        fundingPhaseBlockLength = _fundingPhaseBlockLength;
    }

    function _setRunningPhaseBlockLength(uint256 _runningPhaseBlockLength) internal {
        runningPhaseBlockLength = _runningPhaseBlockLength;
    }

    function _setPostFundingPhaseBlockLength(uint256 _postFundingPhaseBlockLength) internal {
        require(_postFundingPhaseBlockLength < runningPhaseBlockLength, "post_funding_exceeds_runtime");
        postFundingPhaseBlockLength = _postFundingPhaseBlockLength;
    }
}
