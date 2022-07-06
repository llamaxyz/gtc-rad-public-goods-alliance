// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import {IRadicleToken} from "./external/IRadicleToken.sol";
import {GtcRadGrant} from "./GtcRadGrant.sol";

/// @title RadProposalPayload1
/// @author Llama
/// @notice Provides an execute function for Radicle governance to approve pre-defined
///         amount of RAD tokens for the grant contract
contract RadProposalPayload1 {
    /********************************
     *   CONSTANTS AND IMMUTABLES   *
     ********************************/

    IRadicleToken public constant RAD = IRadicleToken(0x31c8EAcBFFdD875c74b94b077895Bd78CF1E64A3);

    GtcRadGrant public immutable gtcRadGrant;
    uint256 public immutable radAmount;

    /*******************
     *   CONSTRUCTOR   *
     *******************/

    constructor(GtcRadGrant _gtcRadGrant, uint256 _radAmount) {
        gtcRadGrant = _gtcRadGrant;
        radAmount = _radAmount;
    }

    /*****************
     *   FUNCTIONS   *
     *****************/

    /// @notice The Radicle governance executor calls this function to implement the proposal
    function execute() external {
        // Approve the GTC <> RAD Public Goods Alliance grant contract to transfer pre-defined amount of RAD tokens
        RAD.approve(address(gtcRadGrant), radAmount);
    }
}
