// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.8.0;

/// The DAO has members and some membership request process.
/// To start we'll make it that anyone can freely join.
/// Maybe more realistic, you have to contribute some kind of surplus to the DAO to join.
///
/// Members contribute all their resources to the DAO voluntarily.
/// The contributions are not enforced, rather this is a voluntary society.
/// It is ones civic duty as a socialist to contribute ALL resources.
///
/// Every so often the pooled resources are split among the members.
/// Every member is allowed to make a claim stating how much they need, and is expected to claim ONLY what they need.
/// Again, it is one's civic duty as a socialist to claim only what they need, and no more.
/// The payout period (the time between consecutive payouts) is at least 100 blocks.
/// Said another way, the payout frequency is at most one payout per hundred blocks.
/// The period is not fixed because they have to be manually triggered.
///
/// The goal of socialism is that all members' needs are met when possible, and the distribution is still fair when not all needs can be met.
/// As long as everyone follows their civic duty, all needs can be met when there are enough resources.
/// In times of plenty, all needs may be met, and a surplus may even begin to form.
/// Unfortunately, in times of scarcity, not all members will have their needs met.
contract SocialismDAO {

    /// The block in which the most recent payout was made.
    uint last_payout_block;

    /// The total number of members in the DAO
    uint num_members = 0;

    /// The complete set of members.
    /// We could use an array here, but a set will be constant time.
    /// Solidity doesn't have a native set, so we use a mapping
    mapping(address => bool) members;


    // The next three storage items work together to make an iterable
    // storage map. They are inspired by https://solidity-by-example.org/app/iterable-mapping/

    /// A mapping from members to the amount of funds they need this payout period.
    /// This is the main data mapping, and in my dream world, it would be the only thing necessary.
    mapping(address => uint) needs;

    /// All members who have currently claimed needs in the previous mapping.
    /// An array is necessary because arrays are iterable in solidity but mappings are not.
    address[] members_with_needs;

    /// The index of each needy member in the previous storage array.
    /// This is necessary for efficient deletion and update.
    mapping(address => uint) needy_member_index;
    
    constructor() payable {
        // We initialize the last payout to the deployment block number
        // so that we are forced to wait at least one period before the first payout.
        last_payout_block = block.number;
    }

    /// A new member joined the Socialism DAO
    event MemberJoined(address joiner);

    /// A member exited the Socialism DAO
    event MemberExited(address exiter);

    /// Someone has contributed resources to the DAO
    event ResourcesContributed(address contributor, uint amount);

    /// Someone has claimed a need to the DAO
    event NeedClaimed(address claimer, uint amount);

    /// The payouts were performed
    event PayoutsPerformed(uint block_number, uint total_payout, uint remaining_surplus);

    /// Join as a new member of the society
    function join() external {
        //TODO
    }

    /// Exit the society.
    function exit() external {
        //TODO
    }

    /// Helper function to remove a member's needs
    /// This helper is useful because removal involves three storage items
    function remove_need(address a) internal {
        //TODO
    }

    /// Check whether an account is a member of the DAO
    function is_member(address x) external view returns(bool) {
        //TODO
    }

    /// Check the currently registered need of the given user.
    function user_need(address x) external view returns(uint256) {
        //TODO
    }

    /// Claim the amount of tokens you need on a roughly 100 block basis.
    ///
    /// If you don't claim a need during a period, your need will be treated as zero.
    /// You may call this method multiple times during a period.
    /// Your latest submission will be accepted.
    ///
    /// In times of plenty your needs will be met; in times of scarcity they may not be.
    function claim_need(uint need) external {
        //TODO
    }

    /// Contribute some of your private funds to the socialism.
    /// As a member of the society, it is your civic duty to call this method as often as you can.
    ///
    /// Although we expect only members to contribute, we will allow donations from non-members too
    function contribute() external payable {
        //TODO
    }

    /// Cause the members to be paid according to their needs.
    ///
    /// Payouts can happen as frequently as every hundred blocks.
    /// But they must be triggered manually by some account calling this function.
    ///
    /// Although we expect that only members will typically call this function, we allow anyone to do so.
    ///
    /// The payout algorithm begins by sorting the members according to their needs with the lowest needs first.
    /// (It may be more gas efficient to maintain a sorted list all along. really IDK.)
    /// Pay them out from the least need to the greatest need.
    /// Each step of the way make sure that the need is less than the even split of the remaining pot.
    /// When we reach a point where members are requesting more than the even split amount, they only get the even split amount.
    /// In these circumstances, the society is not adequately providing for its members.
    /// OTOH, in times of plenty, we will reach the end of the members list with all members' needs met and still have funds in the pot to roll over.
    ///
    /// DESIGN DECISION: Needs do not get reset. They carry over to the next period.
    /// People who know their typical weekly expense will not have to re-submit each time.
    /// This helps save gas fees, but makes it easier to ignore your civic duty to decrease your claim when you need less.
    function trigger_payouts() external {
        //TODO
    }
        
}

// Enhancement: make it work with an ERC20 asset instead of just the native token.

// Enhancement: look at the sorting algo below, and the website from which it came.
// The site mentions that sorting on-chain is inefficient, and a good optimization
// is to sort off-chain and only check the sorting on-chain. Try that advice.
// Your trigger_payouts function should have a new parameter: the pre-sorted list.

// Shamelessly cribbed from https://ethereum.stackexchange.com/a/1518/9963
// Modified slightly to support sorting an array of addresses according to associated values in a map
// instead of sorting an array of addresses directly.
function quickSort(address[] memory arr, mapping(address => uint) storage values, uint left, uint right) view {
    uint i = left;
    uint j = right;
    if (i == j) return;
    uint pivot_index = uint(left + (right - left) / 2);
    address pivot_address = arr[pivot_index];
    uint pivot_value = values[pivot_address];
    while (i <= j) {
        uint i_val = values[arr[uint(i)]];
        uint j_val = values[arr[uint(j)]];
        while (i_val < pivot_value) i++;
        while (pivot_value  < j_val) j--;
        if (i <= j) {
            (arr[uint(i)], arr[uint(j)]) = (arr[uint(j)], arr[uint(i)]);
            i++;
            j--;
        }
    }
    if (left < j)
        quickSort(arr, values, left, j);
    if (i < right)
        quickSort(arr, values, i, right);
}

// Enhancement: When the DAO does not have enough resources to meet everyone's needs,
// it still must decide which members get how much. The algorithm you coded above is one
// reasonable approach, but there are others. Maybe if the DAO has enough to meet
// 80% of the total need, then every member gets 80% of the total need.
//
// Abstract the payout algorithm into a Solidity `Interface`, and move the existing algo
// to a contract that implements the interface. Then implement the new payout algo as
// a second contract. Try to think of a third way the socialists could divide their
// resources during times of want and implement it.

// Enhancement: Make the minimum payout period configurable in the constructor.
