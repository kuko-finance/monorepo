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

abstract contract KukoStatusV1 is Initializable {
    bool public running;
    bool public closed;
    bool public cancelled;

    // solhint-disable-next-line
    function __KukoStatusV1__init() internal initializer {
        running = false;
        closed = false;
        cancelled = false;
    }

    modifier isNotStarted() {
        require(running == false, "round_not_started");
        _;
    }

    modifier isStarted() {
        require(running == true, "round_not_started");
        _;
    }

    modifier isNotClosed() {
        require(closed == false, "round_not_closed");
        _;
    }

    modifier isClosed() {
        require(closed == true, "round_not_closed");
        _;
    }

    modifier isCancelled() {
        require(cancelled == true, "round_not_cancelled");
        _;
    }

    function _setStart(bool _value) internal {
        running = _value;
    }

    function _setClose(bool _value) internal {
        closed = _value;
    }

    function _setCancel(bool _value) internal {
        cancelled = _value;
    }
}
