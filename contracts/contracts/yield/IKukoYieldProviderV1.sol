// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

abstract contract IKukoYieldProviderV1 {

      address[] internal inputTokens;
      address[] internal yieldTokens;
      address[] internal outputTokens;

    function _addInputToken(address _inputToken) internal {
      inputTokens.push(_inputToken);
    }

    function _addYieldToken(address _yieldToken) internal {
      yieldTokens.push(_yieldToken);
    }

    function _addOutputToken(address _outputToken) internal {
      yieldTokens.push(_outputToken);
    }

    /// @notice This method stakes all balance of the currency used by the TBD.
    /// @dev Heavy in gas fees as requires several actions most of the time.
    function invest() internal virtual;

    /// @notice This method retrieves all stakes benefits to the original currency used by the TBD.
    /// @dev Heavy in gas fees as requires several actions most of the time.
    function retrieve() internal virtual;

    function getInputTokens() public view returns (address[] memory) {
      return inputTokens;
    }

    function getYieldTokens() public view returns (address[] memory) {
return yieldTokens;
    }

    function getOutputTokens() public view returns (address[] memory) {
      return outputTokens;
    }
}
