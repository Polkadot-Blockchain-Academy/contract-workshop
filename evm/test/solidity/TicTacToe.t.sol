// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/solidity/TicTacToe.sol";

contract TicTacToeTest is Test {
    TicTacToe public tictactoe;
    address alice = address(0xaAaAaAaaAaAaAaaAaAAAAAAAAaaaAaAaAaaAaaAa);
    address bob = address(0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB);

    event TurnTaken(address player, uint cell_index);

    function setUp() public virtual {
        tictactoe = new TicTacToe(alice, bob);
    }

    function test_first_move_registers_correctly() public {

        // Expect that an event will be emitted
        vm.expectEmit(); // could use args to check more data
        emit TurnTaken(alice, 0);

        // Make the call
        vm.prank(alice);
        tictactoe.take_turn(0);

        // Confirm the storage
        assertEq(tictactoe.get_board()[0], alice);
    }

    function test_can_not_move_on_other_players_turn() public {
        vm.expectRevert("wrong player");
        vm.prank(bob);
        tictactoe.take_turn(0);
    }

    function test_cannot_take_already_occupied_cell() public {
        // Alice claims top left cell
        vm.prank(alice);
        tictactoe.take_turn(0);

        // Bob tries to claim same cell
        vm.expectRevert("Cell already taken");
        vm.prank(bob);
        tictactoe.take_turn(0);
    }
}

contract TicTacToeWinTest is Test {
    TicTacToe public tictactoe;
    address alice = address(0xaAaAaAaaAaAaAaaAaAAAAAAAAaaaAaAaAaaAaaAa);
    address bob = address(0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB);

    event TurnTaken(address player, uint cell_index);
    event GameWon(address winner, WinLocation win_location);
    event GameTied();

    function setUp() public virtual {
        // We want to test stuff related to winning, so we set up the board
        // So that both alice and bob could win by occupying cell six.
        // Of course, it is alice's turn next.
        //
        //  A |   | B
        // ---+---+---
        //  A | B |
        // ---+---+---
        //  6 |   |

        tictactoe = new TicTacToe(alice, bob);

        vm.prank(alice);
        tictactoe.take_turn(0);

        vm.prank(bob);
        tictactoe.take_turn(2);

        vm.prank(alice);
        tictactoe.take_turn(3);

        vm.prank(bob);
        tictactoe.take_turn(4);
    }

    function test_alice_can_win() public {

        // Expect that an event will be emitted
        vm.expectEmit(); // could use args to check more data
        emit TurnTaken(alice, 6);
        vm.expectEmit();
        emit GameWon(alice, WinLocation.LeftColumn);

        // Make the winning call
        vm.prank(alice);
        tictactoe.take_winning_turn(6, WinLocation.LeftColumn);

        // Confirm the winning move is in storage
        assertEq(tictactoe.get_board()[6], alice);
    }

    function test_alice_cannot_falsely_win() public  {
        vm.expectRevert("Invalid win claimed");
        vm.prank(alice);
        // She needed to go in cell 6 to complete the left column,
        // but she went in cell 8 instead
        tictactoe.take_winning_turn(8, WinLocation.LeftColumn);
    }

    function test_alice_cannot_win_with_incorrect_location() public {
        vm.expectRevert("Invalid win claimed");
        vm.prank(alice);
        // She correctly goes in cell 6 to complete the left column,
        // but incorrectly claims the win in the right column
        tictactoe.take_winning_turn(8, WinLocation.RightColumn);
    }

    function test_bob_cannot_claim_alices_win() public {

        // Alice goes in cell 6 to complete the left column,
        // but she doesn't claim her win
        vm.prank(alice);
        tictactoe.take_turn(6);

        // Bob notices her mistake.
        // He can't win himself, but he tries to claim her win
        vm.expectRevert("Invalid win claimed");
        vm.prank(bob);
        tictactoe.take_winning_turn(8, WinLocation.LeftColumn);
    }

    function test_bob_can_win() public {
        // Alice goes in some random cell and does not have a win
        vm.prank(alice);
        tictactoe.take_turn(8);

        // Bob claims cell 6 and wins on the diagonal
        vm.prank(bob);
        tictactoe.take_winning_turn(6, WinLocation.UphillDiagonal);
    }
}

// TODO another whole test contract that tests every possible case of verify_win
