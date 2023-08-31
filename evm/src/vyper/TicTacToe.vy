# @version ^0.3.0

enum WinLocation:
    LeftColumn
    CenterColumn
    RightColumn
    TopRow
    MiddleRow
    BottomRow
    UphillDiagonal
    DownhillDiagonal
    OpponentSurrender

# The two players in the game
player1: address
player2: address

# The number of turns completed in the game so far
num_turns: uint256

# The 3x3 board of moves
#
#  0 | 1 | 2
# ---+---+---
#  3 | 4 | 5
# ---+---+---
#  6 | 7 | 8
#
# row = cell_index / 3
# col = cell_index % 3
board: address[9]

@external
def __init__(p1: address, p2: address):
    self.player1 = p1
    self.player2 = p2
    self.num_turns = 0

# Hacky constructor that uses default players to debug tests.
# This was an attempt to debug tests, but it didn't work
# @external
# def __init__():
#     self.player1 = 0xaAaAaAaaAaAaAaaAaAAAAAAAAaaaAaAaAaaAaaAa
#     self.player2 = 0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB
#     self.num_turns = 0

# A player has taken a turn in the tic tac toe game.
event TurnTaken:
    player: address
    cell_index: uint256

# A player has won the game
event GameWon:
    winner: address
    wim_location: WinLocation

# The game has ended in a draw
event GameTied:
    pass

# TODO is there some way I specify a return type?
@external
@view
def get_board() -> address[9]:
    """ Accessor function for the board storage """
    return self.board

@external
def take_turn(cell_index: uint256):
    """Take a regular non-winning turn in a tic-tac-toe game

    Parameters
    ----------
    cell_index: uint
        the cell that the player is claiming encoded as documented
    """
    self.do_take_turn(cell_index)

@internal
def do_take_turn(cell_index: uint256):
    """Internal helper function to actually do the turn taking logic
    
    This is called by both take_turn and take_winning_turn
    """

    #TODO
    pass

@external
def take_winning_turn(cell_index: uint256, win_location: WinLocation):
    """Take a winning turn in a tic-tac-toe game

    The on-chain logic does not do the heavy lifting of searching all possible win locations
    rather the user is forced to point out exactly where they have won, and the chain
    just confirms it.

    Parameters
    ----------
    cell_index: uint256
        the cell that the player is claiming encoded as documented
    win_location: WinLocation
        the row, column, or diagonal where the player is claiming to have won.
    """

    #TODO
    pass

@internal
@view
def verify_win(winner: address, location: WinLocation) -> bool:
    """ Internal helper function to verify whether a win is valid. """

    #TODO
    return False

@external
def surrender():
    """ Give up on the game allowing the other player to win. """

    #TODO
    pass
