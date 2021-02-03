// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

import "./KukoOptionV1.sol";
import "./KukoActorsV1.sol";
import "./KukoBlocksV1.sol";
import "./KukoreV1.sol";
import "./KukoStatusV1.sol";

abstract contract KukoV1 is
    KukoActorsV1,
    KukoBlocksV1,
    KukoreV1,
    KukoStatusV1,
    ERC1155
{
    string public name;

    IERC20 public token;
    KukoOptionV1[] internal options;
    mapping(uint256 => uint256) internal optionIds;

    constructor(string memory _uri) internal ERC1155(_uri) {}

    function _setToken(address _token) internal {
        token = IERC20(_token);
    }

    function _setName(string memory _name) internal {
        name = _name;
    }

    function start() public isNotStarted {
        _setStart(true);
        _setRunner(msg.sender);
        _captureRunBlock();
        // This call should take all funds and start staking
        _onStart();
    }

    function close() public isStarted isNotClosed isClosable {
        _setCloser(msg.sender);
        _setClose(true);
        // This call should retrieve all funds
        _onClose();
    }

    function cancel() public ownerOnly {
        _setCancel(true);
    }

    ///@return Serialized options
    function getOptions()
        public
        view
        returns (
            uint256[] memory,
            string[] memory,
            string[] memory,
            uint256[] memory,
            int8[] memory,
            uint256[] memory
        )
    {
        uint256 len = options.length;

        uint256[] memory ids = new uint256[](len);
        string[] memory names = new string[](len);
        string[] memory descriptions = new string[](len);
        uint256[] memory keyValues = new uint256[](len);
        int8[] memory finalizations = new int8[](len);
        uint256[] memory shares = new uint256[](len);

        for (uint256 idx = 0; idx < len; ++idx) {
            ids[idx] = options[idx].id;
            names[idx] = options[idx].name;
            descriptions[idx] = options[idx].description;
            keyValues[idx] = options[idx].keyValue;
            finalizations[idx] = options[idx].finalized;
            shares[idx] = options[idx].shares;
        }

        return (ids, names, descriptions, keyValues, finalizations, shares);
    }

    // investment and metadata functions
}
