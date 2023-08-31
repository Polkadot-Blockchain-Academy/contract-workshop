// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.8.0;

/// The colors of the slots placed on the roulette wheel
enum Color {
    Red,
    Black,
    Green
}

/// A Bet on a specific color coming up on the Roulette wheel
struct ColorBet {
    Color color;
    uint amount;
    address beneficiary;
}

/// Models a casino style roulette table
/// https://en.wikipedia.org/wiki/Roulette
/// with these exact tiles
/// https://bfgblog-a.akamaihd.net/uploads/2013/11/2-1-Roulette-Table-Wheel-1024x463.png
contract Roulette {

    /// All existing open color bets
    ColorBet[] color_bets;

    /// The address of the "house" that operates this table.
    /// This is initialized to the address that deployed the contract.
    address house;

    constructor() {
        house = msg.sender;
    }

    /// Funds were added to the table
    event Funded(uint amount);

    /// A Bet for a particular color was placed
    event ColorBetPlaced(ColorBet bet);

    /// A Bet for a particular color was won
    event ColorBetWon(ColorBet bet);

    /// A Bet for a particular color was lost
    event ColorBetLost(ColorBet bet);

    /// Add money to the house's funds.
    /// This can only be called by the house account to help prevent users from
    /// accidentally depositing funds that do not back any bet.
    /// Because we have this explicit function, we do not include a fallback function.
    function fund_table() external payable {
        //TODO
    }

    /// Place a bet on a specific color
    function place_color_bet(Color color) external payable {
        //TODO
    }

    /// Helper function to determine the color of a roulette tile
    function color_of(uint n) internal pure returns(Color) {
        //TODO
    }

    /// Spin the wheel to determine the winning number.
    /// Also calls settle_bets to kick off settlement of all bets.
    function spin() external {

        // Get the "random" result and convert it into a roulette table value.
        // This is not _quite_ perfectly fair because 2^256 % 38 != 0.
        // We could handle that if we want, but we won't yet.
        uint r = uint(blockhash(block.number - 1)); //FIXME we could have an interface for getting randomness and one contract assignment could be to implement a better randomness.
        uint winning_number = r % 38;

        settle_bets(winning_number);
    }

    /// Helper function to settle all bets given a winning number
    /// The payouts can be complex.
    /// https://www.omnicalculator.com/statistics/roulette-payout
    function settle_bets(uint winning_number) internal {
        //TODO
    }
}

// Enhancement: Allow all kinds of other bets like:
// * even / odd
// * one-spot
// * two-spot
// * four-spot
// * Column
// * etc

// Enhancement: read about randomness in the evm and try to find a good source of fair randomness.