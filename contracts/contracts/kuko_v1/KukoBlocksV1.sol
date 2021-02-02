// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

abstract contract KukoBlocksV1 {

    uint256 public startBlock;
    uint256 public runBlock;
    uint256 public fundingPhaseBlockLength;
    uint256 public runningPhaseBlockLength;
    uint256 public postFundingPhaseBlockLength;

    constructor(
        uint256 _fundingPhaseBlockLength,
        uint256 _runningPhaseBlockLength,
        uint256 _postFundingPhaseBlockLength
    )
        internal
    {
        require(
            _postFundingPhaseBlockLength < _runningPhaseBlockLength,
            "post_funding_exceeds_runtime"
        );

        startBlock = block.number;
        fundingPhaseBlockLength = _fundingPhaseBlockLength;
        runningPhaseBlockLength = _runningPhaseBlockLength;
        postFundingPhaseBlockLength = _postFundingPhaseBlockLength;
    }

    function _captureRunBlock() internal {
      runBlock = block.number;
    }

}
