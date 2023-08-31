# @version ^0.3.0

# Docstring standards.
# vyper docs recommended these python docstring standards.
# I'll kind of try to stick to them but not go crazy

# The block in which the most recent payout was made.
last_payout_block: uint256

# The total number of members in the DAO
num_members: uint256

# The complete set of members.
# We could use an array here, but a set will be constant time.
# Vyper doesn't have a native set, so we use a hashmap
members: HashMap[address, bool]


# The next three storage items work together to make an iterable
# storage map. They are inspired by https://solidity-by-example.org/app/iterable-mapping/

# A mapping from members to the amount of funds they need this payout period.
# This is the main data mapping, and in my dream world, it would be the only thing necessary.
needs: HashMap[address, uint256]

# All members who have currently claimed needs in the previous mapping.
# An array is necessary because arrays are iterable in solidity but mappings are not.
members_with_needs: DynArray[address, 100]

# The index of each needy member in the previous storage array.
# This is necessary for efficient deletion and update.
needy_member_index: HashMap[address, uint256]


@external
@payable
def __init__():
    # We initialize the last payout to the deployment block number
    # so that we are forced to wait at least one period before the first payout.
    self.last_payout_block = block.number

# A new member joined the Socialism DAO
event MemberJoined:
    joiner: address

# A member exited the Socialism DAO
event MemberExited:
    exiter: address

# Someone has contributed resources to the DAO
event ResourcesContributed:
    contributor: address
    amount: uint256

# Someone has claimed a need to the DAO
event NeedClaimed:
    claimer: address
    amount: uint256

# The payouts were performed
event PayoutsPerformed:
    block_number: uint256
    total_payout: uint256
    remaining_surplus: uint256

@external
def join():
    """ Join as a new member of the society """
    
    #TODO
    pass

@external
def exit():
    """ Exit the society """

    #TODO
    pass

@internal
def remove_need(a: address):
    """ Helper function to remove a member's needs
        This helper is useful because removal involves three storage items
    """

    #TODO
    pass

@external
@view
def is_member(a: address) -> bool:
    """ Check whether an account is a member of the DAO """
    #TODO
    return False

@external
def claim_need(need: uint256):
    """ Claim the amount of tokens you need on a roughly 100 block basis.
        
        If you don't claim a need during a period, your need will be treated as zero.
        You may call this method multiple times during a period.
        Your latest submission will be accepted.
        
        In times of plenty your needs will be met; in times of scarcity they may not be.
    """

    #TODO
    pass

@external
@payable
def contribute():
    """ Contribute your privately held funds to the socialism.
        
        As a member of the society, it is your civic duty to call this method as often as you can.
        
        Although we expect only members to contribute, we will allow donations from non-members too
    """

    #TODO
    pass

@external
def trigger_payouts():
    """ Cause the members to be paid according to their needs.
        
        Payouts can happen as frequently as every hundred blocks.
        But they must be triggered manually by some account calling this function.
       
        Although we expect that only members will typically call this function, we allow anyone to do so.
       
        The payout algorithm begins by sorting the members according to their needs with the lowest needs first.
        (It may be more gas efficient to maintain a sorted list all along. really IDK.)
        Pay them out from the least need to the greatest need.
        Each step of the way make sure that the need is less than the even split of the remaining pot.
        When we reach a point where members are requesting more than the even split amount, they only get the even split amount.
        In these circumstances, the society is not adequately providing for its members.
        OTOH, in times of plenty, we will reach the end of the members list with all members' needs met and still have funds in the pot to roll over.
       
        DESIGN DECISION: Needs do not get reset. They carry over to the next period.
        People who know their typical weekly expense will not have to re-submit each time.
        This helps save gas fees, but makes it easier to ignore your civic duty to decrease your claim when you need less.
    """

    #TODO
    pass



# Enhancement: make it work with an ERC20 asset instead of just the native token.

# Enhancement: look at the sorting algo below, and https://ethereum.stackexchange.com/a/1518/9963.
# The site mentions that sorting on-chain is inefficient, and a good optimization
# is to sort off-chain and only check the sorting on-chain. Try that advice.
# Your trigger_payouts function should have a new parameter: the pre-sorted list.

@internal
@view
def sort(arr: DynArray[address, 100], left: uint256, right: uint256):
    #TODO
    pass

# Enhancement: When the DAO does not have enough resources to meet everyone's needs,
# it still must decide which members get how much. The algorithm you coded above is one
# reasonable approach, but there are others. Maybe if the DAO has enough to meet
# 80% of the total need, then every member gets 80% of the total need.
#
# Abstract the payout algorithm into a Solidity `Interface`, and move the existing algo
# to a contract that implements the interface. Then implement the new payout algo as
# a second contract. Try to think of a third way the socialists could divide their
# resources during times of want and implement it.

# Enhancement: Make the minimum payout period configurable in the constructor.
