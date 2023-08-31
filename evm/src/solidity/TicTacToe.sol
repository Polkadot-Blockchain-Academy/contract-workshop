// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.8.0;

enum WinLocation {
    LeftColumn,
    CenterColumn,
    RightColumn,
    TopRow,
    MiddleRow,
    BottomRow,
    UphillDiagonal,
    DownhillDiagonal,
    OpponentSurrender
}

/// @title A contract that allows two users to play a game of tic tac toe between themselves.
contract TicTacToe {

    /// The two players in the game
    address player1;
    address player2;

    /// The number of turns completed in the game so far
    uint num_turns;
    
    /// The 3x3 board of moves
    ///
    ///  0 | 1 | 2
    /// ---+---+---
    ///  3 | 4 | 5
    /// ---+---+---
    ///  6 | 7 | 8
    ///
    /// row = cell_index / 3
    /// col = cell_index % 3
    address[9] board;

    constructor(address p1, address p2) {
        player1 = p1;
        player2 = p2;
        num_turns = 0;
    }

    /// A player has taken a turn in the tic tac toe game.
    event TurnTaken(address player, uint cell_index);

    /// A player has won the game
    event GameWon(address winner, WinLocation win_location);

    /// The game has ended in a draw
    event GameTied();

    /// Return the current state of the board
    function get_board() external view returns(address[9] memory) {
        return board;
    }

    /// @dev Take a regular non-winning turn in a tic-tac-toe game
    /// @param cell_index the cell that the player is claiming encoded as documented
    function take_turn(uint cell_index) external {
        do_take_turn(cell_index);
    }

    /// Internal helper function to actually do the turn taking logic
    /// This is called by both take_turn and take_winning_turn
    function do_take_turn(uint cell_index) internal {
        //TODO
    }

    /// @dev Take a winning turn in a tic-tac-toe game
    /// @param cell_index the cell that the player is claiming encoded as documented
    /// @param win_location the row, column, or diagonal where the player is claiming to have won.
    /// The on-chain logic does not do the heavy lifting of searching all possible win locations
    /// rather the user is forced to point out exactly where they have won, and the chain
    /// just confirms it.
    function take_winning_turn(uint cell_index, WinLocation win_location) external {
        //TODO
    }

    /// Internal helper function to verify whether a win is valid.
    function verify_win(address winner, WinLocation location) view internal returns(bool) {
        //TODO
    }

    /// Give up on the game allowing the other player to win.
    function surrender() external {
        //TODO
    }
}

// Enhancement: Require a security deposit from each player, and if anyone claims
// to have won incorrectly, their deposit it slashed.

// Enhancement: Allow players to bet on a game.

// Enhancement: Allow ending games early when it is inevitable that a draw
// will happen, but the board is not yet full. This will require one player
// proposing an early draw, and the other player accepting.