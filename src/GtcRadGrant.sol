// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";

/// @title GtcRadGrant
/// @author Llama
/// @notice GTC <> RAD Public Goods Alliance grant contract
contract GtcRadGrant {
    using SafeERC20 for IERC20;

    /********************************
     *   CONSTANTS AND IMMUTABLES   *
     ********************************/

    address public constant GTC_TREASURY = 0x57a8865cfB1eCEf7253c27da6B4BC3dAEE5Be518;
    address public constant RAD_TREASURY = 0x8dA8f82d2BbDd896822de723F55D6EdF416130ba;

    IERC20 public constant GTC = IERC20(0xDe30da39c46104798bB5aA3fe8B9e0e1F348163F);
    IERC20 public constant RAD = IERC20(0x31c8EAcBFFdD875c74b94b077895Bd78CF1E64A3);

    // 90 Day TWAP
    uint256 public constant GTC_AMOUNT = 500000e18;
    uint256 public constant RAD_AMOUNT = 680272108e15;

    /*************************
     *   STORAGE VARIABLES   *
     *************************/

    bool public hasGrantOccured;

    /**************
     *   EVENTS   *
     **************/

    event Grant(address indexed gtcTreasury, address indexed radTreasury, uint256 gtcAmount, uint256 radAmount);

    /****************************
     *   ERRORS AND MODIFIERS   *
     ****************************/

    error GrantAlreadyOccured();

    /*****************
     *   FUNCTIONS   *
     *****************/

    /// @notice Atomically grant pre-determined and pre-approved token amounts b/w GTC and RAD treasuries
    function grant() external {
        // Check in case of infinite approvals and prevent a second swap
        if (hasGrantOccured) revert GrantAlreadyOccured();
        hasGrantOccured = true;

        // Execute the GTC <> RAD Public Goods Alliance grant
        GTC.safeTransferFrom(GTC_TREASURY, RAD_TREASURY, GTC_AMOUNT);
        RAD.safeTransferFrom(RAD_TREASURY, GTC_TREASURY, RAD_AMOUNT);

        emit Grant(GTC_TREASURY, RAD_TREASURY, GTC_AMOUNT, RAD_AMOUNT);
    }
}
