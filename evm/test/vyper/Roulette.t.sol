// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../VyperTest.sol";

// We use the solidity starter code as the ABI definition.
// The vyper code has to meet the same definition for the tests to work.
// This could maybe be enforced a little mroe nicely with json abis.
// https://ethereum.stackexchange.com/a/129798/9963 but for now we don't need enforcement.
import "../../src/solidity/Roulette.sol";

// We use the solidity test suite as out base suite and inhereit all the cases
import "../solidity/Roulette.t.sol";

/// Testing Contract for the Vyper implementation.
/// This inherits from the Solidity test contract and overrides it constructor.
contract VyperRouletteundingTests is RouletteFundingTests, VyperTest {
    function setUp() override public {
        string memory vyperContractPath = "evm/src/vyper/Roulette.vy";
        address vyContractAddress = deployContract(vyperContractPath);
        roulette = Roulette(vyContractAddress); 
    }
}

/// Testing Contract for the Vyper implementation.
/// This inherits from the Solidity test contract and overrides it constructor.
/// TODO These tests are failing on the example solutions.
/// IDK wy. Debugging is welcome.
contract VyperRouletteTests is RouletteTests, VyperTest {
    function setUp() override public {
        string memory vyperContractPath = "evm/src/vyper/Roulette.vy";
        address vyContractAddress = deployContract(vyperContractPath);

        // Deploy and fund the roulette table with 10k ether.
        // This test contract is the house.
        roulette = RouletteHarness(vyContractAddress);
        roulette.fund_table{value: 10_000 ether}();
        
        // Initialize the player account with 100 tokens.
        player = address(0);
        deal(player, 100 ether);
    }
}