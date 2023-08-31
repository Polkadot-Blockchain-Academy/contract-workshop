// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../VyperTest.sol";
import "../../src/solidity/TicTacToe.sol";
import "../solidity/TicTacToe.t.sol";

/// Testing Contract for the Vyper implementation.
/// This inherits from the Solidity test contract and overrides it constructor.
/// TODO These tests are failing on the example solutions.
/// IDK wy. Debugging is welcome.
contract VyperTicTacToeTest is TicTacToeTest, VyperTest {
    
    function setUp() override public {
        string memory vyperContractPath = "evm/src/vyper/Roulette.vy";
        // address vyContractAddress = deployContract(vyperContractPath, abi.encode(alice, bob));
        address vyContractAddress = deployContract(vyperContractPath);

        tictactoe = TicTacToe(vyContractAddress);
    }
}

/// Testing Contract for the Vyper implementation.
/// This inherits from the Solidity test contract and overrides it constructor.
/// TODO These tests are failing on the example solutions.
/// IDK wy. Debugging is welcome.
contract VyperTicTacToeWinTest is TicTacToeWinTest, VyperTest {
    
    function setUp() override public {
        string memory vyperContractPath = "evm/src/vyper/Roulette.vy";
        // address vyContractAddress = deployContract(vyperContractPath, abi.encode(alice, bob));
        address vyContractAddress = deployContract(vyperContractPath);

        tictactoe = TicTacToe(vyContractAddress);

        // We want to test stuff related to winning, so we set up the board
        // So that both alice and bob could win by occupying cell six.
        // Of course, it is alice's turn next.
        //
        //  A |   | B
        // ---+---+---
        //  A | B |
        // ---+---+---
        //  6 |   |

        vm.prank(alice);
        tictactoe.take_turn(0);

        vm.prank(bob);
        tictactoe.take_turn(2);

        vm.prank(alice);
        tictactoe.take_turn(3);

        vm.prank(bob);
        tictactoe.take_turn(4);
    }
}

// TODO another whole test contract that tests every possible case of verify_win
