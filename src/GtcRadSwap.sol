// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

contract GtcRadSwap {
    uint256 public num;

    constructor(uint256 _num) {
        num = _num;
    }

    function changeNum(uint256 _num) external {
        num = _num;
    }
}
