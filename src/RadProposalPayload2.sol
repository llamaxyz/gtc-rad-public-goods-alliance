// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import {IGitcoinToken} from "./external/IGitcoinToken.sol";

/// @title RadProposalPayload2
/// @author Llama
/// @notice Provides an execute function for Radicle governance to delegate received GTC tokens to the Radicle Multisig
contract RadProposalPayload2 {
    /********************************
     *   CONSTANTS AND IMMUTABLES   *
     ********************************/

    IGitcoinToken public constant GTC = IGitcoinToken(0xDe30da39c46104798bB5aA3fe8B9e0e1F348163F);

    address public immutable RAD_MULTISIG;

    /*******************
     *   CONSTRUCTOR   *
     *******************/

    constructor(address _radMultisig) {
        RAD_MULTISIG = _radMultisig;
    }

    /*****************
     *   FUNCTIONS   *
     *****************/

    /// @notice The Radicle governance executor calls this function to implement the proposal
    function execute() external {
        // Delegate the received GTC tokens in RAD Treasury to the RAD Multisig
        GTC.delegate(RAD_MULTISIG);
    }
}
