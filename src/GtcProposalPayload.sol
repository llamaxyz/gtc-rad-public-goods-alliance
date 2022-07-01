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

    IGitcoinToken public constant GTC = IGitcoinToken(0xDe30da39c46104798bB5aA3fe8B9e0e1F348163F);
    IRadicleToken public constant RAD = IRadicleToken(0x31c8EAcBFFdD875c74b94b077895Bd78CF1E64A3);

    GtcRadGrant public immutable GTC_RAD_GRANT;
    address public immutable GTC_MULTISIG;
    uint256 public immutable GTC_AMOUNT;

    /*******************
     *   CONSTRUCTOR   *
     *******************/

    constructor(
        GtcRadGrant _gtcRadGrant,
        address _gtcMultisig,
        uint256 _gtcAmount
    ) {
        GTC_RAD_GRANT = _gtcRadGrant;
        GTC_MULTISIG = _gtcMultisig;
        GTC_AMOUNT = _gtcAmount;
    }

    /*****************
     *   FUNCTIONS   *
     *****************/

    /// @notice The Gitcoin governance executor calls this function to implement the proposal
    function execute() external {
        // Approve the GTC <> RAD Public Goods Alliance grant contract to transfer pre-defined amount of GTC tokens
        GTC.approve(address(GTC_RAD_GRANT), GTC_AMOUNT);
        // Execute the GTC <> RAD Public Goods Alliance grant
        GTC_RAD_GRANT.grant();
        // Delegate the received RAD tokens in GTC Treasury to the GTC Multisig
        RAD.delegate(GTC_MULTISIG);
    }
}
