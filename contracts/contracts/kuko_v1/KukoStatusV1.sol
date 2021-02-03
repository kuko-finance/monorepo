// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

abstract contract KukoStatusV1 {
    bool public running = false;
    bool public closed = false;
    bool public cancelled = false;

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
