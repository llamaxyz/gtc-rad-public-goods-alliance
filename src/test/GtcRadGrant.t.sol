// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

// testing libraries
import "@ds/test.sol";
import "@std/console.sol";
import {stdCheats} from "@std/stdlib.sol";
import {Vm} from "@std/Vm.sol";
import {DSTestPlus} from "@solmate/test/utils/DSTestPlus.sol";

import {GtcRadGrant} from "../GtcRadGrant.sol";
import {RadProposalPayload1} from "../RadProposalPayload1.sol";
import {GtcProposalPayload} from "../GtcProposalPayload.sol";
import {RadProposalPayload2} from "../RadProposalPayload2.sol";

contract GtcRadGrantTest is DSTestPlus, stdCheats {
    Vm private vm = Vm(HEVM_ADDRESS);

    GtcRadGrant public gtcRadGrant;
    RadProposalPayload1 public radProposalPayload1;
    GtcProposalPayload public gtcProposalPayload;
    RadProposalPayload2 public radProposalPayload2;

    address public constant LLAMA_TREASURY = 0xA519a7cE7B24333055781133B13532AEabfAC81b;
    // To be change-d later
    address public constant GTC_MULTISIG = 0x03C82B63B276c0D3050A49210c31036d3155e705;
    address public constant RAD_MULTISIG = 0x33e626727B9Ecf64E09f600A1E0f5adDe266a0DF;
    uint256 public constant GTC_AMOUNT = 500000e18;
    uint256 public constant RAD_AMOUNT = 885990e18;
    uint256 public constant LLAMA_GTC_PAYMENT_AMOUNT = 6945e18;
    uint256 public constant LLAMA_RAD_PAYMENT_AMOUNT = 11765e18;

    function setUp() public {
        gtcRadGrant = new GtcRadGrant(GTC_AMOUNT, RAD_AMOUNT);
        vm.label(address(gtcRadGrant), "GtcRadGrant");

        radProposalPayload1 = new RadProposalPayload1(gtcRadGrant, RAD_AMOUNT);
        vm.label(address(radProposalPayload1), "RadProposalPayload1");

        gtcProposalPayload = new GtcProposalPayload(gtcRadGrant, GTC_MULTISIG, GTC_AMOUNT, LLAMA_GTC_PAYMENT_AMOUNT);
        vm.label(address(gtcProposalPayload), "GtcProposalPayload");

        radProposalPayload2 = new RadProposalPayload2(RAD_MULTISIG, LLAMA_RAD_PAYMENT_AMOUNT);
        vm.label(address(radProposalPayload2), "RadProposalPayload2");
    }
}
