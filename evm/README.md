# Ethereum Virtual Machine Contracts

This folder is dedicated to smart contracts that run on the EVM.

This folder is structured as a [foundry project](https://book.getfoundry.sh/).

## Source

We have both Solidity code (in the `src/solidity` directory), and Vyper code (in the `src/vyper` directory).

Currently the solidity code is more carefully documented, and has a working test suite.
For these reasons, Solidity is a first class language, and Vyper is not yet.

## Testing

Test coverage for each project can be found in the `test` directory which is also divided into `vyper` and `solidity` subdirectories.
For example, `test/solidity/Roulette.t.sol` contains the tests for the solidity implementation of the roulette project.

Foundry projects use the `forge` command to run tests.
To test all evm projects you can simply run `forge test`.
But to test a specific project, you can run a more focused command like `forge test --match-path evm/test/solidity/Roulette.t.sol`

For lots more testing hints, see `forge test --help`.

## Learning Resources

If you are doing this workshop as part of the PBA, your instructors have already given you a short course in programming the EVM.
Even so, you may find these additional learning resources useful:

- https://docs.soliditylang.org/en/v0.8.20/
- https://docs.vyperlang.org/en/stable/toctree.html
