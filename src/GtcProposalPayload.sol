// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import {IGitcoinToken} from "./external/IGitcoinToken.sol";
import {IRadicleToken} from "./external/IRadicleToken.sol";
import {GtcRadGrant} from "./GtcRadGrant.sol";

/// @title GtcProposalPayload
/// @author Llama
/// @notice Provides an execute function for Gitcoin governance to approve pre-defined amount of GTC tokens,
///         execute the grant and delegate received RAD tokens to the Gitcoin Multisig
contract GtcProposalPayload {
    /********************************
     *   CONSTANTS AND IMMUTABLES   *
     ********************************/

    address public constant LLAMA_TREASURY = 0xA519a7cE7B24333055781133B13532AEabfAC81b;

    IGitcoinToken public constant GTC = IGitcoinToken(0xDe30da39c46104798bB5aA3fe8B9e0e1F348163F);
    IRadicleToken public constant RAD = IRadicleToken(0x31c8EAcBFFdD875c74b94b077895Bd78CF1E64A3);

    GtcRadGrant public immutable gtcRadGrant;
    address public immutable gtcMultisig;
    uint256 public immutable gtcAmount;
    uint256 public immutable llamaGtcPaymentAmount;

    /*******************
     *   CONSTRUCTOR   *
     *******************/

    constructor(
        GtcRadGrant _gtcRadGrant,
        address _gtcMultisig,
        uint256 _gtcAmount,
        uint256 _llamaGtcPaymentAmount
    ) {
        gtcRadGrant = _gtcRadGrant;
        gtcMultisig = _gtcMultisig;
        gtcAmount = _gtcAmount;
        llamaGtcPaymentAmount = _llamaGtcPaymentAmount;
    }

    /*****************
     *   FUNCTIONS   *
     *****************/

    /// @notice The Gitcoin governance executor calls this function to implement the proposal
    function execute() external {
        // Approve the GTC <> RAD Public Goods Alliance grant contract to transfer pre-defined amount of GTC tokens
        GTC.approve(address(gtcRadGrant), gtcAmount);
        // Execute the GTC <> RAD Public Goods Alliance grant
        gtcRadGrant.grant();
        // Delegate the received RAD tokens in GTC Treasury to the GTC Multisig
        RAD.delegate(gtcMultisig);
        // Payment to Llama Treasury
        GTC.transfer(LLAMA_TREASURY, llamaGtcPaymentAmount);
    }
}
