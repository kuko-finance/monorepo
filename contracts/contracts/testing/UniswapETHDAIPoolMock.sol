// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// https://etherscan.io/address/0xa478c2975ab1ea89e8196811f51a7b7ade33eb11#readContract
contract UniswapETHDAIPoolMock is ERC20("DAI", "DAI") {
    uint256 private initBlock = block.number;

    // DAI / ETH
    function getReserves()
        public
        view
        returns (
            uint112 _reserve0,
            uint112 _reserve1,
            uint32 _blockTimestampLast
        )
    {
        return (
            1000000000 + uint112((block.number - initBlock) * 1000),
            1000000,
            0
        );
    }
}
