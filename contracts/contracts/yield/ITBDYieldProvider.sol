// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

abstract contract ITBDYieldProvider {
    /// @notice This method stakes all balance of the currency used by the TBD.
    /// @dev Heavy in gas fees as requires several actions most of the time.
    function investToken() internal virtual;

    /// @notice This method retrieves all stakes benefits to the original currency used by the TBD.
    /// @dev Heavy in gas fees as requires several actions most of the time.
    function retrieveTokenFromInvestment() internal virtual;
}
