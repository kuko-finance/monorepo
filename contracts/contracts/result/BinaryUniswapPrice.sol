// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "../kuko_v1/KukoOptionsManagerV1.sol";
import "@uniswap/uniswap-v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";

abstract contract BinaryUniswapPrice is KukoOptionsManagerV1, Initializable {
    IUniswapV2Pair private uniswapPairAddress;
    uint8 public asset;
    uint256 public closePrice;
    bool public resolved = false;

    uint256 public constant HIGHER_BID_ID = 0;
    uint256 public constant LOWER_BID_ID = 1;

    uint256 public higherRealId;
    uint256 public lowerRealId;

    // solhint-disable-next-line
    function __BinaryUniswapPrice__init(address _uniswapPairAddress, uint8 _asset) internal initializer {
        require(_asset < 2, "invalid_asset_position");
        uniswapPairAddress = IUniswapV2Pair(_uniswapPairAddress);
        asset = _asset;
    }

    function _initialize(uint256 optionCount) internal override returns (KukoOptionV1[] memory) {
        (uint112 asset0Reserve, uint112 asset1Reserve, ) = uniswapPairAddress.getReserves();

        uint256 openPrice = asset1Reserve / asset0Reserve;

        KukoOptionV1[] memory result = new KukoOptionV1[](2);

        result[0] = KukoOptionV1({
            id: optionCount + HIGHER_BID_ID,
            name: "higher_bid",
            keyValue: openPrice,
            finalized: 0,
            shares: 0
        });

        higherRealId = result[0].id;

        result[1] = KukoOptionV1({
            id: optionCount + LOWER_BID_ID,
            name: "lower_bid",
            keyValue: openPrice,
            finalized: 0,
            shares: 0
        });

        lowerRealId = result[0].id;

        return result;
    }

    function _isManager(uint256 id) internal view override returns (bool) {
        return id == lowerRealId || id == higherRealId;
    }

    function _resolve(KukoOptionV1 memory option) internal override returns (int8) {
        if (!resolved) {
            (uint112 asset0Reserve, uint112 asset1Reserve, ) = uniswapPairAddress.getReserves();

            if (asset == 0) {
                closePrice = asset1Reserve / asset0Reserve;
            } else {
                closePrice = asset0Reserve / asset1Reserve;
            }
            resolved = true;
        }

        if (option.id == lowerRealId) {
            return (option.keyValue > closePrice) ? int8(1) : int8(-1);
        } else if (option.id == higherRealId) {
            return (option.keyValue <= closePrice) ? int8(1) : int8(-1);
        }
        return int8(0);
    }
}
