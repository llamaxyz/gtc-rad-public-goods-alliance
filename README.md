# Gitcoin <> Radicle Public Goods Alliance

This repository contains the swap contract and the test cases for exectuing the Public Goods alliance on Gitcoin and Radicle Governance.

## Public Goods Alliance Implementation

The full implementation of this Public Goods Alliance involves deploying the `GtcRadGrant` contract and 2 Proposals on Radicle's governance and 1 Proposal on Gitcoin's governance to be executed in the following order:

### Deploy GtcRadGrant contract

- Deploy the GtcRadGrant contract.

### Radicle Proposal 1

- Call `approve(address,uint256)` on the Radicle token contract (`0x31c8EAcBFFdD875c74b94b077895Bd78CF1E64A3`) with calldata of the address of the deployed GtcRadGrant contract and amount of RAD tokens to be approved.

### Gitcoin Proposal

- Call `approve(address,uint256)` on the Gitcoin token contract (`0xDe30da39c46104798bB5aA3fe8B9e0e1F348163F`) with calldata of the address of the deployed GtcRadGrant contract and amount of GTC tokens to be approved (`500,000 GTC`)

- Call `grant()` on the deployed GtcRadGrant contract.

- Call `delegate(address)` on the Radicle token contract (`0x31c8EAcBFFdD875c74b94b077895Bd78CF1E64A3`) with calldata of the Gitcoin Multisig address (`0xBD8d617Ac53c5Efc5fBDBb51d445f7A2350D4940`).

### Radicle Proposal 2

- Call `delegate(address)` on the Gitcoin token contract (`0xDe30da39c46104798bB5aA3fe8B9e0e1F348163F`) with call data of the Radicle Multisig address (`0x93F80a67FdFDF9DaF1aee5276Db95c8761cc8561`).

- Call `transfer(address,uint256)` on the Radicle token contract (`0x31c8EAcBFFdD875c74b94b077895Bd78CF1E64A3`) with calldata of the Llama Treasury address (`0xA519a7cE7B24333055781133B13532AEabfAC81b`) and the Llama Payment amount in RAD tokens.

## Installation

It requires [Foundry](https://github.com/gakonst/foundry) installed to run. You can find instructions here [Foundry installation](https://github.com/gakonst/foundry#installation).

To set up the project manually, run the following commands:

```sh
$ git clone https://github.com/llama-community/gtc-rad-public-goods-alliance.git
$ cd gtc-rad-public-goods-alliance
$ npm install
$ forge install
```

## Setup

Duplicate `.env.example` and rename to `.env`:

- Add a valid mainnet URL for an Ethereum JSON-RPC client for the `RPC_URL` variable.
- Add the latest mainnet block number for the `BLOCK_NUMBER` variable.
- Add a valid Etherscan API Key for the `ETHERSCAN_API_KEY` variable.

### Commands

- `make build` - build the project
- `make test [optional](V={1,2,3,4,5})` - run tests (with different debug levels if provided)
- `make match MATCH=<TEST_FUNCTION_NAME> [optional](V=<{1,2,3,4,5}>)` - run matched tests (with different debug levels if provided)

### Deploy and Verify

- `Mainnet`: When you're ready to deploy and verify, run `./scripts/deploy_verify_mainnet.sh` and follow the prompts.
- `Testnet`: When you're ready to deploy and verify, run `./scripts/deploy_verify_testnet.sh` and follow the prompts.

To confirm the deploy was successful, re-run your test suite but use the newly created contract address.
