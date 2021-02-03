// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

abstract contract KukoYieldManagerV1 {
    address internal inputToken;
    address[] internal yieldTokens;
    address[] internal outputTokens;

    function _setInputToken(address _inputToken) internal {
        inputToken = _inputToken;
    }

    function _addYieldToken(address _yieldToken) internal {
        yieldTokens.push(_yieldToken);
    }

    function _addOutputToken(address _outputToken) internal {
        yieldTokens.push(_outputToken);
    }

    /// @notice This method stakes all balance of the currency used by the TBD.
    /// @dev Heavy in gas fees as requires several actions most of the time.
    function _invest() internal virtual;

    /// @notice This method retrieves all stakes benefits to the original currency used by the TBD.
    /// @dev Heavy in gas fees as requires several actions most of the time.
    function _retrieve() internal virtual;

    // Count of all investments in current input token value
    function _totalFunds() internal virtual returns (uint256);

    function getInputToken() external view returns (address) {
        return inputToken;
    }

    function getYieldTokens() external view returns (address[] memory) {
        return yieldTokens;
    }

    function getOutputTokens() external view returns (address[] memory) {
        return outputTokens;
    }
}
