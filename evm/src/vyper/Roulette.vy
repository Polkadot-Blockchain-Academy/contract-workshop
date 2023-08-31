# @version ^0.3.0

enum Color:
    RED
    BLACK
    GREEN

struct ColorBet:
    color: Color
    amount: uint256
    beneficiary: address

house: address
color_bets: DynArray[ColorBet, 100]

@external
def __init__():
    self.house = msg.sender

event Funded:
    amount: uint256

event ColorBetPlaced:
    bet: ColorBet

event ColorBetWon:
    bet: ColorBet

event ColorBetLost:
    bet: ColorBet

@external
@payable
def fund_table():
    """ Add money to the house's funds

        This can only be called by the house account to help prevent users from
        accidentally depositing funds that do not back any bet.
        Because we have this explicit function, we do not include a fallback function.
    """

    #TODO
    pass

@external
@payable
def place_color_bet(color: Color):
    """ Place a bet on a specific color """

    #TODO
    pass

@pure
@internal
def color_of(n: uint256) -> Color:
    """ Helper function to determine the color of a roulette tile """

    #TODO
    return Color.GREEN

@external
def spin():
    """ Spin the wheel to determine the winning number.
    
        Also calls settle_bets to kick off settlement of all bets.
    """

    # Get the "random" result and convert it into a roulette table value.
    # This is not _quite_ perfectly fair because 2^256 % 38 != 0.
    # We could handle that if we want, but we won't yet.
    r: uint256 = convert(blockhash(block.number - 1),  uint256) # TODO we could have an interface for getting randomness and one contract assignment could be to implement abetter randomness.
    winning_number: uint256 = r % 38

    self.settle_bets(winning_number)

@internal
def settle_bets(winning_number: uint256):
    """ Helper function to settle all bets given a winning number
    
    The payouts can be complex.
    https://www.omnicalculator.com/statistics/roulette-payout
    """

    #TODO
    pass



# TODO the following two functions should NOT exist, and are only there
# expose otherwise internal helper functions for the purposes of unit testing

@external
def exposed_settle_bets(winning_number: uint256):
    self.settle_bets(winning_number)

@external
def exposed_color_of(n: uint256) -> Color:
    return self.color_of(n)