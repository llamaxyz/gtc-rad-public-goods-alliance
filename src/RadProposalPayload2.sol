// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import {IGitcoinToken} from "./external/IGitcoinToken.sol";
import {GtcRadGrant} from "./GtcRadGrant.sol";

/// @title RadProposalPayload2
/// @author Llama
/// @notice Provides an execute function for Radicle governance to delegate preset amount of RAD tokens to the Radicle Multisig.
contract RadProposalPayload1 {
    /********************************
     *   CONSTANTS AND IMMUTABLES   *
     ********************************/

    IGitcoinToken public constant GTC = IGitcoinToken(0xDe30da39c46104798bB5aA3fe8B9e0e1F348163F);

    address public immutable radMultisig;

    /*******************
     *   CONSTRUCTOR   *
     *******************/

    constructor(address _radMultisig) {
        radMultisig = _radMultisig;
    }

    /*****************
     *   FUNCTIONS   *
     *****************/

    function execute() external {
        GTC.delegate(radMultisig);
    }
}
