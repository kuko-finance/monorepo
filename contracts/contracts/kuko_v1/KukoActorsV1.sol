// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

abstract contract KukoActorsV1 {
    address public launcher;
    address public runner;
    address public closer;
    address public owner;

    uint256 public launcherShare;
    uint256 public runnerShare;
    uint256 public closerShare;
    uint256 public ownerShare;

    modifier ownerOnly() {
        require(msg.sender == owner, "not_owner");
        _;
    }

    constructor(
        address _owner,
        uint256 _ownerShare,
        uint256 _launcherShare,
        uint256 _runnerShare,
        uint256 _closerShare
    ) internal {
        require(_launcherShare < 1000000, "launcher_share_too_high");
        require(_runnerShare < 1000000, "runner_share_too_high");
        require(_closerShare < 1000000, "closer_share_too_high");
        require(_ownerShare < 1000000, "owner_share_too_high");

        owner = _owner;
        ownerShare = _ownerShare;
        launcherShare = _launcherShare;
        runnerShare = _runnerShare;
        closerShare = _closerShare;
    }

    function _setLauncher(address _launcher) internal {
      launcher = _launcher;
    }

    function _setRunner(address _runner) internal {
      runner = _runner;
    }

    function _setCloser(address _closer) internal {
      closer = _closer;
    }
}

