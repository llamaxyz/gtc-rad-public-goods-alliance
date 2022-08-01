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

contract GtcRadGrantTest is DSTestPlus, stdCheats {
    event Grant(address indexed gtcTreasury, address indexed radTreasury, uint256 gtcAmount, uint256 radAmount);

    Vm private vm = Vm(HEVM_ADDRESS);

    IGitcoinGovernor public constant GITCOIN_GOVERNOR = IGitcoinGovernor(0xDbD27635A534A3d3169Ef0498beB56Fb9c937489);
    IGitcoinTimelock public constant GITCOIN_TIMELOCK =
        IGitcoinTimelock(payable(0x57a8865cfB1eCEf7253c27da6B4BC3dAEE5Be518));
    IGitcoinToken public constant GITCOIN_TOKEN = IGitcoinToken(0xDe30da39c46104798bB5aA3fe8B9e0e1F348163F);
    IRadicleGovernor public constant RADICLE_GOVERNOR = IRadicleGovernor(0x690e775361AD66D1c4A25d89da9fCd639F5198eD);
    IRadicleTimelock public constant RADICLE_TIMELOCK =
        IRadicleTimelock(payable(0x8dA8f82d2BbDd896822de723F55D6EdF416130ba));
    IRadicleToken public constant RADICLE_TOKEN = IRadicleToken(0x31c8EAcBFFdD875c74b94b077895Bd78CF1E64A3);

    address public constant LLAMA_TREASURY = 0xA519a7cE7B24333055781133B13532AEabfAC81b;
    address public constant GTC_MULTISIG = 0xBD8d617Ac53c5Efc5fBDBb51d445f7A2350D4940;
    address public constant RAD_MULTISIG = 0x93F80a67FdFDF9DaF1aee5276Db95c8761cc8561;

    address public constant MOCK_RADICLE_PROPOSER = 0x464D78a5C97A2E2E9839C353ee9B6d4204c90B0b;
    address public constant MOCK_GITCOIN_PROPOSER = 0xc2E2B715d9e302947Ec7e312fd2384b5a1296099;

    string public constant DESCRIPTION = "GTC <> RAD Public Goods Alliance";

    // To be change-d later
    uint256 public constant GTC_AMOUNT = 500000e18;
    uint256 public constant RAD_AMOUNT = 885990e18;
    uint256 public constant LLAMA_RAD_PAYMENT_AMOUNT = 11765e18;
    // To be change-d later

    GtcRadGrant public gtcRadGrant;

    address[] private radWhales = [
        0x464D78a5C97A2E2E9839C353ee9B6d4204c90B0b,
        0x6AE55181F90c954993789546956A8453E63B0015,
        0x14E94aaCa7eBad882516eb969a7B67787a860B64,
        0x6851566a6183Eff8440456a58823B87107eAd707,
        0x6B0807396Ca3Da7eC2a72cd192693F2251320F92,
        0xEA95cfB5Dd624F43775b372db0ED2D8d0073E91C
    ];

    address[] private gtcWhales = [
        0xc2E2B715d9e302947Ec7e312fd2384b5a1296099,
        0x34aA3F359A9D614239015126635CE7732c18fDF3,
        0x7E052Ef7B4bB7E5A45F331128AFadB1E589deaF1
    ];

    function setUp() public {
        gtcRadGrant = new GtcRadGrant(GTC_AMOUNT, RAD_AMOUNT);
        vm.label(address(gtcRadGrant), "GtcRadGrant");

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

    /******************
     *   Test Cases   *
     ******************/

    function testRadicleProposal() public {
        assertEq(RADICLE_TOKEN.allowance(address(RADICLE_TIMELOCK), address(gtcRadGrant)), 0);
        // Pre llama payment balances
        uint256 initialRadicleTreasuryRadicleBalance = RADICLE_TOKEN.balanceOf(address(RADICLE_TIMELOCK));
        uint256 initialLlamaTreasuryRadicleBalance = RADICLE_TOKEN.balanceOf(LLAMA_TREASURY);

        _runRadicleProposal();

        assertEq(RADICLE_TOKEN.allowance(address(RADICLE_TIMELOCK), address(gtcRadGrant)), RAD_AMOUNT);
        // Checking final post llama payment balances
        assertEq(
            initialRadicleTreasuryRadicleBalance - LLAMA_RAD_PAYMENT_AMOUNT,
            RADICLE_TOKEN.balanceOf(address(RADICLE_TIMELOCK))
        );
        assertEq(
            initialLlamaTreasuryRadicleBalance + LLAMA_RAD_PAYMENT_AMOUNT,
            RADICLE_TOKEN.balanceOf(LLAMA_TREASURY)
        );
        // Checking that GTC tokens of Radicle treasury has been delegated to Radicle Multisig
        assertEq(GITCOIN_TOKEN.delegates(address(RADICLE_TIMELOCK)), RAD_MULTISIG);
    }

    function _runRadicleProposal() private {
        address[] memory targets = new address[](3);
        uint256[] memory values = new uint256[](3);
        string[] memory signatures = new string[](3);
        bytes[] memory calldatas = new bytes[](3);

        // Approve the GTC <> RAD Public Goods Alliance grant contract to transfer pre-defined amount of RAD tokens
        targets[0] = address(RADICLE_TOKEN);
        values[0] = uint256(0);
        signatures[0] = "approve(address,uint256)";
        calldatas[0] = abi.encode(address(gtcRadGrant), RAD_AMOUNT);

        // Delegate the GTC tokens in RAD Treasury to the RAD Multisig
        targets[1] = address(GITCOIN_TOKEN);
        values[1] = uint256(0);
        signatures[1] = "delegate(address)";
        calldatas[1] = abi.encode(RAD_MULTISIG);

        // Payment to Llama Treasury in RAD tokens
        targets[2] = address(RADICLE_TOKEN);
        values[2] = uint256(0);
        signatures[2] = "transfer(address,uint256)";
        calldatas[2] = abi.encode(LLAMA_TREASURY, LLAMA_RAD_PAYMENT_AMOUNT);

        uint256 proposalID = _radicleCreateProposal(targets, values, signatures, calldatas, DESCRIPTION);
        _radicleRunGovProcess(proposalID);
    }

    function testGitcoinProposal() public {
        _runRadicleProposal();

        assertEq(GITCOIN_TOKEN.allowance(address(GITCOIN_TIMELOCK), address(gtcRadGrant)), 0);
        // Pre-grant balances
        uint256 initialGitcoinTreasuryGitcoinBalance = GITCOIN_TOKEN.balanceOf(address(GITCOIN_TIMELOCK));
        uint256 initialGitcoinTreasuryRadicleBalance = RADICLE_TOKEN.balanceOf(address(GITCOIN_TIMELOCK));
        uint256 initialRadicleTreasuryGitcoinBalance = GITCOIN_TOKEN.balanceOf(address(RADICLE_TIMELOCK));
        uint256 initialRadicleTreasuryRadicleBalance = RADICLE_TOKEN.balanceOf(address(RADICLE_TIMELOCK));

        vm.expectEmit(true, true, false, true);
        emit Grant(address(GITCOIN_TIMELOCK), address(RADICLE_TIMELOCK), GTC_AMOUNT, RAD_AMOUNT);

        _runGitcoinProposal();

        // Checking final post grant + Gitcoin llama payment balances
        assertEq(initialGitcoinTreasuryGitcoinBalance - GTC_AMOUNT, GITCOIN_TOKEN.balanceOf(address(GITCOIN_TIMELOCK)));
        assertEq(initialGitcoinTreasuryRadicleBalance + RAD_AMOUNT, RADICLE_TOKEN.balanceOf(address(GITCOIN_TIMELOCK)));
        assertEq(initialRadicleTreasuryGitcoinBalance + GTC_AMOUNT, GITCOIN_TOKEN.balanceOf(address(RADICLE_TIMELOCK)));
        assertEq(initialRadicleTreasuryRadicleBalance - RAD_AMOUNT, RADICLE_TOKEN.balanceOf(address(RADICLE_TIMELOCK)));
        // Checking that RAD tokens of Gitcoin treasury has been delegated to Gitcoin Multisig
        assertEq(RADICLE_TOKEN.delegates(address(GITCOIN_TIMELOCK)), GTC_MULTISIG);
    }

    function _runGitcoinProposal() private {
        address[] memory targets = new address[](3);
        uint256[] memory values = new uint256[](3);
        string[] memory signatures = new string[](3);
        bytes[] memory calldatas = new bytes[](3);

        // Approve the GTC <> RAD Public Goods Alliance grant contract to transfer pre-defined amount of GTC tokens
        targets[0] = address(GITCOIN_TOKEN);
        values[0] = uint256(0);
        signatures[0] = "approve(address,uint256)";
        calldatas[0] = abi.encode(address(gtcRadGrant), GTC_AMOUNT);

        // Execute the GTC <> RAD Public Goods Alliance grant
        targets[1] = address(gtcRadGrant);
        values[1] = uint256(0);
        signatures[1] = "grant()";
        bytes memory emptyBytes;
        calldatas[1] = emptyBytes;

        // Delegate the received RAD tokens in GTC Treasury to the GTC Multisig
        targets[2] = address(RADICLE_TOKEN);
        values[2] = uint256(0);
        signatures[2] = "delegate(address)";
        calldatas[2] = abi.encode(GTC_MULTISIG);

        uint256 proposalID = _gitcoinCreateProposal(targets, values, signatures, calldatas, DESCRIPTION);
        _gitcoinRunGovProcess(proposalID);
    }

    function testSecondGrantCall() public {
        _runRadicleProposal();
        _runGitcoinProposal();

        vm.expectRevert(GtcRadGrant.GrantAlreadyOccured.selector);
        gtcRadGrant.grant();
    }

    /***************************
     *   Radicle Gov Process   *
     ***************************/

    function _radicleCreateProposal(
        address[] memory targets,
        uint256[] memory values,
        string[] memory signatures,
        bytes[] memory calldatas,
        string memory description
    ) private returns (uint256 proposalID) {
        // Proposer that has > 1M RAD votes
        vm.prank(MOCK_RADICLE_PROPOSER);
        proposalID = RADICLE_GOVERNOR.propose(targets, values, signatures, calldatas, description);
    }

    function _radicleVoteOnProposal(uint256 proposalID) private {
        (, , uint256 startBlock, , , , , ) = RADICLE_GOVERNOR.proposals(proposalID);
        // Skipping Proposal delay of 1 block
        vm.roll(startBlock + 1);
        // Hitting quorum of > 4M RAD votes
        for (uint256 i; i < radWhales.length; i++) {
            vm.prank(radWhales[i]);
            RADICLE_GOVERNOR.castVote(proposalID, true);
        }
    }

    function _radicleSkipVotingPeriod(uint256 proposalID) private {
        (, , , uint256 endBlock, , , , ) = RADICLE_GOVERNOR.proposals(proposalID);
        // Skipping Voting period of 3 days worth of blocks
        vm.roll(endBlock + 1);
    }

    function _radicleQueueProposal(uint256 proposalID) private {
        RADICLE_GOVERNOR.queue(proposalID);
    }

    function _radicleSkipQueuePeriod(uint256 proposalID) private {
        (, uint256 eta, , , , , , ) = RADICLE_GOVERNOR.proposals(proposalID);
        // Skipping Queue period of 2 days
        vm.warp(eta);
    }

    function _radicleExecuteProposal(uint256 proposalID) private {
        RADICLE_GOVERNOR.execute(proposalID);
    }

    function _radicleRunGovProcess(uint256 proposalID) private {
        _radicleVoteOnProposal(proposalID);
        _radicleSkipVotingPeriod(proposalID);
        _radicleQueueProposal(proposalID);
        _radicleSkipQueuePeriod(proposalID);
        _radicleExecuteProposal(proposalID);
    }

    /***************************
     *   Gitcoin Gov Process   *
     ***************************/

    function _gitcoinCreateProposal(
        address[] memory targets,
        uint256[] memory values,
        string[] memory signatures,
        bytes[] memory calldatas,
        string memory description
    ) private returns (uint256 proposalID) {
        // Proposer that has > 1M GTC votes
        vm.prank(MOCK_GITCOIN_PROPOSER);
        proposalID = GITCOIN_GOVERNOR.propose(targets, values, signatures, calldatas, description);
    }

    function _gitcoinVoteOnProposal(uint256 proposalID) private {
        (, , , uint256 startBlock, , , , , ) = GITCOIN_GOVERNOR.proposals(proposalID);
        // Skipping Proposal delay of 2 days worth of blocks
        vm.roll(startBlock + 1);
        // Hitting quorum of > 2.5M GTC votes
        for (uint256 i; i < gtcWhales.length; i++) {
            vm.prank(gtcWhales[i]);
            GITCOIN_GOVERNOR.castVote(proposalID, true);
        }
    }

    function _gitcoinSkipVotingPeriod(uint256 proposalID) private {
        (, , , , uint256 endBlock, , , , ) = GITCOIN_GOVERNOR.proposals(proposalID);
        // Skipping Voting period of 7 days worth of blocks
        vm.roll(endBlock + 1);
    }

    function _gitcoinQueueProposal(uint256 proposalID) private {
        GITCOIN_GOVERNOR.queue(proposalID);
    }

    function _gitcoinSkipQueuePeriod(uint256 proposalID) private {
        (, , uint256 eta, , , , , , ) = GITCOIN_GOVERNOR.proposals(proposalID);
        // Skipping Queue period of 2 days
        vm.warp(eta);
    }

    function _gitcoinExecuteProposal(uint256 proposalID) private {
        GITCOIN_GOVERNOR.execute(proposalID);
    }

    function _gitcoinRunGovProcess(uint256 proposalID) private {
        _gitcoinVoteOnProposal(proposalID);
        _gitcoinSkipVotingPeriod(proposalID);
        _gitcoinQueueProposal(proposalID);
        _gitcoinSkipQueuePeriod(proposalID);
        _gitcoinExecuteProposal(proposalID);
    }
}
