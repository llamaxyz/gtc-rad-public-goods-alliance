// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import {IRadicleToken} from "./external/IRadicleToken.sol";
import {GtcRadGrant} from "./GtcRadGrant.sol";

/// @title RadProposalPayload2
/// @author Llama
/// @notice Provides an execute function for Radicle governance to delegate preset amount of RAD tokens to the Radicle Multisig.
contract RadProposalPayload1 {
    /********************************
     *   CONSTANTS AND IMMUTABLES   *
     ********************************/

    IRadicleToken public constant RAD = IRadicleToken(0x31c8EAcBFFdD875c74b94b077895Bd78CF1E64A3);

    GtcRadGrant public immutable gtcRadGrant;
    uint256 public immutable radAmount;
    address public immutable radMultisig;

    /*******************
     *   CONSTRUCTOR   *
     *******************/

    constructor(
        GtcRadGrant _gtcRadGrant,
        uint256 _radAmount,
        address _radMultisig
    ) {
        gtcRadGrant = _gtcRadGrant;
        radAmount = _radAmount;
        radMultisig = _radMultisig;
    }

    /*****************
     *   FUNCTIONS   *
     *****************/

    function execute() external {
        RAD.delegate(radMultisig);
    }
}
