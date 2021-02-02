// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

abstract contract KukoStatusV1 {

    bool public running = false;
    bool public closed = false;
    bool public cancelled = false;

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

