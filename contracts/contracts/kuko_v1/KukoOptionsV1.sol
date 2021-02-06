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

struct KukoOptionV1 {
    uint256 id;
    string name;
    uint256 keyValue;
    int8 finalized;
    uint256 shares;
}

abstract contract KukoOptionsV1 {
    KukoOptionV1[] public options;
    mapping(uint256 => uint256) internal optionIds;

    ///@return Serialized options
    function getOptions()
        public
        view
        returns (
            uint256[] memory,
            string[] memory,
            uint256[] memory,
            int8[] memory,
            uint256[] memory
        )
    {
        uint256 len = options.length;

        uint256[] memory ids = new uint256[](len);
        string[] memory names = new string[](len);
        uint256[] memory keyValues = new uint256[](len);
        int8[] memory finalizations = new int8[](len);
        uint256[] memory shares = new uint256[](len);

        for (uint256 idx = 0; idx < len; ++idx) {
            ids[idx] = options[idx].id;
            names[idx] = options[idx].name;
            keyValues[idx] = options[idx].keyValue;
            finalizations[idx] = options[idx].finalized;
            shares[idx] = options[idx].shares;
        }

        return (ids, names, keyValues, finalizations, shares);
    }
}
