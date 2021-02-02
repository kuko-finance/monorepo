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

    uint256 public loserShare;

    modifier ownerOnly() {
        require(msg.sender == owner, "not_owner");
        _;
    }

    function _setOwnerShare(uint256 _ownerShare) internal {
        require(_ownerShare < 1000000, "owner_share_too_high");
      ownerShare = _ownerShare;
    }

    function _setLauncherShare(uint256 _launcherShare) internal {
        require(_launcherShare < 1000000, "launcher_share_too_high");
      launcherShare = _launcherShare;
    }

    function _setRunnerShare(uint256 _runnerShare) internal {
        require(_runnerShare < 1000000, "runner_share_too_high");
      runnerShare = _runnerShare;
    }

    function _setCloserShare(uint256 _closerShare) internal {
        require(_closerShare < 1000000, "closer_share_too_high");
      closerShare = _closerShare;
    }

    function _setLoserShare(uint256 _loserShare) internal {
        require(_loserShare < 1000000, "loser_share_too_high");
      closerShare = _loserShare;
    }

    function _setOwner(address _owner) internal {
      owner = _owner;
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

