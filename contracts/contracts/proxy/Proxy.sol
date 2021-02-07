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

// This Proxy is on purpose non upgradeable and used mainly for lowering deployment fees
contract Proxy {
    constructor(bytes memory constructData, address contractLogic) public {
        bool success = false;
        // solhint-disable-next-line
        assembly {
            // solium-disable-line
            sstore(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7, contractLogic)
            success := delegatecall(
                sub(gas(), 10000),
                contractLogic,
                add(constructData, 32),
                mload(constructData),
                0x0,
                0x0
            )
        }
        require(success, "construction_error");
    }

    function implementation() internal view returns (address impl) {
        // solhint-disable-next-line
        assembly {
            impl := sload(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7)
        }
    }

    fallback() external payable {
        // solhint-disable-next-line
        assembly {
            let contractLogic := sload(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7)

            calldatacopy(0x0, 0x0, calldatasize())
            let success := delegatecall(sub(gas(), 10000), contractLogic, 0x0, calldatasize(), 0, 0)
            let retSz := returndatasize()
            returndatacopy(0, 0, retSz)
            switch success
                case 0 {
                    revert(0, retSz)
                }
                default {
                    return(0, retSz)
                }
        }
    }
}
