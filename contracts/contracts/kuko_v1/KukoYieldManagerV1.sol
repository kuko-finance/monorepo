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

/// @notice This section is in charge of all yield management.
abstract contract KukoYieldManagerV1 {
    address internal inputToken;
    address[] internal yieldTokens;
    address[] internal outputTokens;

    /// @notice Change the input token address
    function _setInputToken(address _inputToken) internal {
        inputToken = _inputToken;
    }

    /// @notice Adds a new yield token address
    function _addYieldToken(address _yieldToken) internal {
        yieldTokens.push(_yieldToken);
    }

    /// @notice Adds a new output token address
    function _addOutputToken(address _outputToken) internal {
        yieldTokens.push(_outputToken);
    }

    /// @notice This method stakes all balance of the currency used by the TBD.
    /// @dev Heavy in gas fees as requires several actions most of the time.
    function _invest() internal virtual;

    /// @notice This method retrieves all stakes benefits to the original currency used by the TBD.
    /// @dev Heavy in gas fees as requires several actions most of the time.
    function _retrieve() internal virtual;

    /// @notice Utility to retrieve current investment values
    function _totalFunds() internal view virtual returns (uint256);

    /// @notice Retrieve input token address
    function getInputToken() external view returns (address) {
        return inputToken;
    }

    /// @notice Retrieve yield token addresses
    function getYieldTokens() external view returns (address[] memory) {
        return yieldTokens;
    }

    /// @notice Retrieve output token addresses
    function getOutputTokens() external view returns (address[] memory) {
        return outputTokens;
    }
}
