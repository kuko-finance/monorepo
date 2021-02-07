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

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";

import "./KukoOptionsV1.sol";
import "./KukoActorsV1.sol";
import "./KukoBlocksV1.sol";
import "./KukoreV1.sol";
import "./KukoStatusV1.sol";

abstract contract KukoV1 is
    Initializable,
    ERC1155Upgradeable,
    KukoActorsV1,
    KukoBlocksV1,
    KukoreV1,
    KukoStatusV1,
    KukoOptionsV1
{
    string public name;
    IERC20 public token;

    // solhint-disable-next-line
    function __KukoV1_init(string memory _uri) internal initializer {
        __ERC1155_init(_uri);
        __KukoBlocksV1__init();
        __KukoStatusV1__init();
    }

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
        _setClose(true);
    }

    // investment and metadata functions
}
