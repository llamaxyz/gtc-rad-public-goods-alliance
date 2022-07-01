// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

// testing libraries
import "@ds/test.sol";
import "@std/console.sol";
import {stdCheats} from "@std/stdlib.sol";
import {Vm} from "@std/Vm.sol";
import {DSTestPlus} from "@solmate/test/utils/DSTestPlus.sol";

import {GtcRadGrant} from "../GtcRadGrant.sol";

contract GtcRadGrantTest is DSTestPlus, stdCheats {
    Vm private vm = Vm(HEVM_ADDRESS);
    GtcRadGrant public gtcRadGrant;

    function setUp() public {
        gtcRadGrant = new GtcRadGrant(500000e18, 885990e18);
        vm.label(address(gtcRadGrant), "GtcRadGrant");
    }
}
