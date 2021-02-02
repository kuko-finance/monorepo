// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

struct KukoOptionV1 {
    uint256 id;
    string name;
    string description;
    uint256 keyValue;
    int8 finalized;
    uint256 shares;
}

