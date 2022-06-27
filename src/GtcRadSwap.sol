// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";

/// @title GtcRadSwap
/// @author Llama
/// @notice GTC <> RAD Public Goods Alliance swap contract
contract GtcRadSwap {
    using SafeERC20 for IERC20;

    /********************************
     *   CONSTANTS AND IMMUTABLES   *
     ********************************/

    address public constant GTC_DAO_TREASURY = 0x57a8865cfB1eCEf7253c27da6B4BC3dAEE5Be518;
    address public constant RAD_DAO_TREASURY = 0x8dA8f82d2BbDd896822de723F55D6EdF416130ba;

    IERC20 public constant GTC = IERC20(0xDe30da39c46104798bB5aA3fe8B9e0e1F348163F);
    IERC20 public constant RAD = IERC20(0x31c8EAcBFFdD875c74b94b077895Bd78CF1E64A3);

    uint256 public immutable gtcAmount;
    uint256 public immutable radAmount;

    /**************
     *   EVENTS   *
     **************/

    event Swap(uint256 gtcAmount, uint256 radAmount);

    /*******************
     *   CONSTRUCTOR   *
     *******************/

    constructor(uint256 _gtcAmount, uint256 _radAmount) {
        gtcAmount = _gtcAmount;
        radAmount = _radAmount;
    }

    /*****************
     *   FUNCTIONS   *
     *****************/

    /// @notice Atomically swap pre-determined token amounts b/w GTC and RAD treasuries
    function swap() external {
        GTC.safeTransferFrom(GTC_DAO_TREASURY, RAD_DAO_TREASURY, gtcAmount);
        RAD.safeTransferFrom(RAD_DAO_TREASURY, GTC_DAO_TREASURY, radAmount);
        emit Swap(gtcAmount, radAmount);
    }
}
