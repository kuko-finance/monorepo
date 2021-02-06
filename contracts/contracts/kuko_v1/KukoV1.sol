// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

import "./KukoOptionsV1.sol";
import "./KukoActorsV1.sol";
import "./KukoBlocksV1.sol";
import "./KukoreV1.sol";
import "./KukoStatusV1.sol";

abstract contract KukoV1 is KukoActorsV1, KukoBlocksV1, KukoreV1, KukoStatusV1, KukoOptionsV1, ERC1155 {
    string public name;

    IERC20 public token;

    constructor(string memory _uri) internal ERC1155(_uri) {}

    function _setToken(address _token) internal {
        token = IERC20(_token);
    }

    function _setName(string memory _name) internal {
        name = _name;
    }

    function start() public override isNotStarted {
        _setStart(true);
        _setRunner(msg.sender);
        _captureRunBlock();
        // This call should take all funds and start staking
        _onStart();
    }

    function close() public override isStarted isNotClosed isClosable {
        _setCloser(msg.sender);
        _setClose(true);
        // This call should retrieve all funds
        _onClose();
    }

    function cancel() public override ownerOnly {
        _setCancel(true);
    }

    // investment and metadata functions
}
