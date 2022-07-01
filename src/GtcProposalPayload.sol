// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import {IGitcoinToken} from "./external/IGitcoinToken.sol";
import {IRadicleToken} from "./external/IRadicleToken.sol";
import {GtcRadGrant} from "./GtcRadGrant.sol";

/// @title GtcProposalPayload
/// @author Llama
/// @notice Provides an execute function for Gitcoin governance to approve,swap and delegate preset amount of GTC tokens
contract GtcProposalPayload {
    /********************************
     *   CONSTANTS AND IMMUTABLES   *
     ********************************/

    IGitcoinToken public constant GTC = IGitcoinToken(0xDe30da39c46104798bB5aA3fe8B9e0e1F348163F);
    IRadicleToken public constant RAD = IRadicleToken(0x31c8EAcBFFdD875c74b94b077895Bd78CF1E64A3);

    GtcRadGrant public immutable gtcRadGrant;
    address public immutable gtcMultisig;
    uint256 public immutable gtcAmount;

    /*******************
     *   CONSTRUCTOR   *
     *******************/

    constructor(
        GtcRadGrant _gtcRadGrant,
        address _gtcMultisig,
        uint256 _gtcAmount
    ) {
        gtcRadGrant = _gtcRadGrant;
        gtcMultisig = _gtcMultisig;
        gtcAmount = _gtcAmount;
    }

    /*****************
     *   FUNCTIONS   *
     *****************/

    function execute() external {
        GTC.approve(address(gtcRadGrant), gtcAmount);
        gtcRadGrant.grant();
        RAD.delegate(gtcMultisig);
    }
}
