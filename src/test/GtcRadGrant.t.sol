// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

// testing libraries
import "@ds/test.sol";
import "@std/console.sol";
import {stdCheats} from "@std/stdlib.sol";
import {Vm} from "@std/Vm.sol";
import {DSTestPlus} from "@solmate/test/utils/DSTestPlus.sol";

// contract dependencies
import {IGitcoinGovernor} from "../external/IGitcoinGovernor.sol";
import {IGitcoinTimelock} from "../external/IGitcoinTimelock.sol";
import {IGitcoinToken} from "../external/IGitcoinToken.sol";
import {IRadicleGovernor} from "../external/IRadicleGovernor.sol";
import {IRadicleTimelock} from "../external/IRadicleTimelock.sol";
import {IRadicleToken} from "../external/IRadicleToken.sol";

import {GtcRadGrant} from "../GtcRadGrant.sol";
import {RadProposalPayload1} from "../RadProposalPayload1.sol";
import {GtcProposalPayload} from "../GtcProposalPayload.sol";
import {RadProposalPayload2} from "../RadProposalPayload2.sol";

contract GtcRadGrantTest is DSTestPlus, stdCheats {
    Vm private vm = Vm(HEVM_ADDRESS);

    // CONSTANTS
    IGitcoinGovernor public constant GITCOIN_GOVERNOR = IGitcoinGovernor(0xDbD27635A534A3d3169Ef0498beB56Fb9c937489);
    IGitcoinTimelock public constant GITCOIN_TIMELOCK =
        IGitcoinTimelock(payable(0x57a8865cfB1eCEf7253c27da6B4BC3dAEE5Be518));
    IGitcoinToken public constant GITCOIN_TOKEN = IGitcoinToken(0xDe30da39c46104798bB5aA3fe8B9e0e1F348163F);
    IRadicleGovernor public constant RADICLE_GOVERNOR = IRadicleGovernor(0x690e775361AD66D1c4A25d89da9fCd639F5198eD);
    IRadicleTimelock public constant RADICLE_TIMELOCK =
        IRadicleTimelock(payable(0x8dA8f82d2BbDd896822de723F55D6EdF416130ba));
    IRadicleToken public constant RADICLE_TOKEN = IRadicleToken(0x31c8EAcBFFdD875c74b94b077895Bd78CF1E64A3);

    address public constant LLAMA_TREASURY = 0xA519a7cE7B24333055781133B13532AEabfAC81b;
    address public constant MOCK_RADICLE_PROPOSER = 0x464D78a5C97A2E2E9839C353ee9B6d4204c90B0b;
    address public constant MOCK_GITCOIN_PROPOSER = 0x894Aa5F1E45454677A8560ddE3B45Cb5C427Ef92;
    // To be change-d later
    address public constant GTC_MULTISIG = 0x03C82B63B276c0D3050A49210c31036d3155e705;
    address public constant RAD_MULTISIG = 0x33e626727B9Ecf64E09f600A1E0f5adDe266a0DF;
    uint256 public constant GTC_AMOUNT = 500000e18;
    uint256 public constant RAD_AMOUNT = 885990e18;
    uint256 public constant LLAMA_GTC_PAYMENT_AMOUNT = 6945e18;
    uint256 public constant LLAMA_RAD_PAYMENT_AMOUNT = 11765e18;

    GtcRadGrant public gtcRadGrant;
    RadProposalPayload1 public radProposalPayload1;
    GtcProposalPayload public gtcProposalPayload;
    RadProposalPayload2 public radProposalPayload2;

    function setUp() public {
        gtcRadGrant = new GtcRadGrant(GTC_AMOUNT, RAD_AMOUNT);
        vm.label(address(gtcRadGrant), "GtcRadGrant");

        radProposalPayload1 = new RadProposalPayload1(gtcRadGrant, RAD_AMOUNT);
        vm.label(address(radProposalPayload1), "RadProposalPayload1");

        gtcProposalPayload = new GtcProposalPayload(gtcRadGrant, GTC_MULTISIG, GTC_AMOUNT, LLAMA_GTC_PAYMENT_AMOUNT);
        vm.label(address(gtcProposalPayload), "GtcProposalPayload");

        radProposalPayload2 = new RadProposalPayload2(RAD_MULTISIG, LLAMA_RAD_PAYMENT_AMOUNT);
        vm.label(address(radProposalPayload2), "RadProposalPayload2");

        vm.label(address(GITCOIN_GOVERNOR), "GITCOIN_GOVERNOR");
        vm.label(address(GITCOIN_TIMELOCK), "GITCOIN_TIMELOCK");
        vm.label(address(GITCOIN_TOKEN), "GITCOIN_TOKEN");
        vm.label(address(RADICLE_GOVERNOR), "RADICLE_GOVERNOR");
        vm.label(address(RADICLE_TIMELOCK), "RADICLE_TIMELOCK");
        vm.label(address(RADICLE_TOKEN), "RADICLE_TOKEN");
        vm.label(MOCK_RADICLE_PROPOSER, "MOCK_RADICLE_PROPOSER");
        vm.label(MOCK_GITCOIN_PROPOSER, "MOCK_GITCOIN_PROPOSER");
        vm.label(LLAMA_TREASURY, "LLAMA_TREASURY");
        vm.label(GTC_MULTISIG, "GTC_MULTISIG");
        vm.label(RAD_MULTISIG, "RAD_MULTISIG");
    }

    // function _createRadicleProposal() public {
    //     bytes memory emptyBytes;
    //     address[] memory targets;
    //     uint256[] memory values;
    //     string[] memory signatures;
    //     bytes[] memory calldatas;

    //     targets.push(address(radProposalPayload1));
    //     values.push(0);
    //     signatures.push("execute()");
    //     calldatas.push(emptyBytes);

    //     vm.prank(LLAMA_PROPOSER);
    // }
}
