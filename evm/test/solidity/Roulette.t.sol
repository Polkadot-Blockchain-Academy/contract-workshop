// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../../src/solidity/Roulette.sol";


/// Test harness contract simply inherits from the main
/// Roulette contract and exposes its internal methods
/// https://book.getfoundry.sh/tutorials/best-practices#internal-functions
contract RouletteHarness is Roulette {
    function exposed_settle_bets(uint winning_number) public {
        settle_bets(winning_number);
    }

    function exposed_color_of(uint n) public pure returns(Color) {
        return color_of(n);
    }
}

contract RouletteFundingTests is Test {
    Roulette public roulette;

    event Funded(uint amount);

    function setUp() public virtual {
        roulette = new Roulette(); 
    }

    function test_house_can_fund_table() public {

        // The new table should have no funds initially
        assertEq(address(roulette).balance, 0);

        // Expect that an event will be emitted
        vm.expectEmit(); // could use args to check more data
        emit Funded(100 ether);

        // Fund it and make sure it gets the funds
        roulette.fund_table{value: 100 ether}();
        assertEq(address(roulette).balance, 100 ether);
    }

    function test_rando_can_not_fund_table() public {
        vm.expectRevert(bytes("Table can only be funded by house"));
        hoax(address(0), 100 ether);
        roulette.fund_table{value: 100 ether}();
    }

    function test_fallback_function_is_disabled() public {
        vm.expectRevert();
        hoax(address(0), 100 ether);
        payable(address(roulette)).transfer(10 ether);
    }
}

contract RouletteTests is Test {
    RouletteHarness public roulette;
    address public player;
    
    // Wow, I guess we're supposed to copy the events over.
    // Kind of janky on Foundry's part
    // https://book.getfoundry.sh/cheatcodes/expect-emit
    event ColorBetPlaced(ColorBet bet);
    event ColorBetWon(ColorBet bet);
    event ColorBetLost(ColorBet bet);

    function setUp() public virtual {
        // Deploy and fund the roulette table with 10k ether.
        // This test contract is the house.
        roulette = new RouletteHarness();
        roulette.fund_table{value: 10_000 ether}();
        
        // Initialize the player account with 100 tokens.
        player = address(0);
        deal(player, 100 ether);
    }

    function test_can_bet_red() public {

        // Expect that an event will be emitted
        vm.expectEmit(); // could use args to check more data
        emit ColorBetPlaced(ColorBet(Color.Red, 10 ether, player));

        assertEq(player.balance, 100 ether);
        // Player places the bet
        vm.prank(player);
        roulette.place_color_bet{value: 10 ether}(Color.Red);

        // Make sure the player's balance is decreased while a bet is open
        assertEq(player.balance, 90 ether);
    }

    function test_can_not_bet_higher_stakes_than_casino_can_cover() public {
        //TODO try to place a bet so high that if you win the max amount,
        // the casino can't cover their losses.
        // This should revert.

        // A more subtle test in the same vein is to place a bet that the casino
        // can cover. Then place a second bet that the casino could also cover
        // on its own, but where the sum of the two cannot be covered.

        // We could really get crazy on making the max loss calculation accurate.
        // For example it is not always possible for the house to lose all its bets.
        // If some players have bet on red and others on black the house will win at least some of those bets.
    
    }

    function test_can_not_bet_more_than_you_have() public {
        //TODO actually, is this even a good test to have?
        // In FRAME you would test this because the value would just
        // be a number and your pallet would have to call the currency trait.
        // But here the balance checks are handles by the evm...
    }

    function test_color_of() public view {
        // Why can't I use assertEq here?
        assert(roulette.exposed_color_of(0) == Color.Green);
        assert(roulette.exposed_color_of(1) == Color.Red);
        assert(roulette.exposed_color_of(2) == Color.Black);
        assert(roulette.exposed_color_of(3) == Color.Red);
        assert(roulette.exposed_color_of(4) == Color.Black);
        assert(roulette.exposed_color_of(5) == Color.Red);
        assert(roulette.exposed_color_of(6) == Color.Black);
        assert(roulette.exposed_color_of(7) == Color.Red);
        assert(roulette.exposed_color_of(8) == Color.Black);
        assert(roulette.exposed_color_of(9) == Color.Red);
        assert(roulette.exposed_color_of(10) == Color.Black);
        assert(roulette.exposed_color_of(11) == Color.Black);
        assert(roulette.exposed_color_of(12) == Color.Red);
        assert(roulette.exposed_color_of(13) == Color.Black);
        assert(roulette.exposed_color_of(14) == Color.Red);
        assert(roulette.exposed_color_of(15) == Color.Black);
        assert(roulette.exposed_color_of(16) == Color.Red);
        assert(roulette.exposed_color_of(17) == Color.Black);
        assert(roulette.exposed_color_of(18) == Color.Red);
        assert(roulette.exposed_color_of(19) == Color.Red);
        assert(roulette.exposed_color_of(20) == Color.Black);
        assert(roulette.exposed_color_of(21) == Color.Red);
        assert(roulette.exposed_color_of(22) == Color.Black);
        assert(roulette.exposed_color_of(23) == Color.Red);
        assert(roulette.exposed_color_of(24) == Color.Black);
        assert(roulette.exposed_color_of(25) == Color.Red);
        assert(roulette.exposed_color_of(26) == Color.Black);
        assert(roulette.exposed_color_of(27) == Color.Red);
        assert(roulette.exposed_color_of(28) == Color.Black);
        assert(roulette.exposed_color_of(29) == Color.Black);
        assert(roulette.exposed_color_of(30) == Color.Red);
        assert(roulette.exposed_color_of(31) == Color.Black);
        assert(roulette.exposed_color_of(32) == Color.Red);
        assert(roulette.exposed_color_of(33) == Color.Black);
        assert(roulette.exposed_color_of(34) == Color.Red);
        assert(roulette.exposed_color_of(35) == Color.Black);
        assert(roulette.exposed_color_of(36) == Color.Red);
        assert(roulette.exposed_color_of(37) == Color.Green);
    }

    function test_player_wins_red_bet() public {

        // Player places the bet
        vm.prank(player);
        roulette.place_color_bet{value: 10 ether}(Color.Red);

        // Expect that an event will be emitted
        vm.expectEmit(); // could use args to check more data
        emit ColorBetWon(ColorBet(Color.Red, 10 ether, player));

        // Spin is made and Red 19 is the winner.
        roulette.exposed_settle_bets(19);

        // Player's balance should be the original 100 + 10 of winnings
        assertEq(player.balance, 110 ether);

        //TODO check that all bets are cleared after each of these
    }

    function test_player_loses_black_bet() public {

        // Player places the bet
        vm.prank(player);
        roulette.place_color_bet{value: 10 ether}(Color.Black);

        // Expect that an event will be emitted
        vm.expectEmit(); // could use args to check more data
        emit ColorBetLost(ColorBet(Color.Black, 10 ether, player));

        // Spin is made and Red 19 is the winner.
        roulette.exposed_settle_bets(19);

        // Player's balance should be the original 100 - 10 of losses
        assertEq(player.balance, 90 ether);
    }

    function test_player_wins_green_bet() public {
        // Player places the bet
        vm.prank(player);
        roulette.place_color_bet{value: 10 ether}(Color.Green);

        // Expect that an event will be emitted
        vm.expectEmit(); // could use args to check more data
        emit ColorBetWon(ColorBet(Color.Green, 10 ether, player));

        // Spin is made and Green 00 is the winner.
        roulette.exposed_settle_bets(37);

        // Player's balance should be the original 100 + 170 of winnings
        assertEq(player.balance, 270 ether);
    }

    function test_two_players_win_bets() public {
        address other_player = address(0xb0b);
        deal(other_player, 100 ether);

        // Player places a bet
        vm.prank(player);
        roulette.place_color_bet{value: 10 ether}(Color.Black);

        // Another player places another bet
        vm.prank(other_player);
        roulette.place_color_bet{value: 10 ether}(Color.Black);

        // Spin is made and Black 2 is the winner; They both win!
        roulette.exposed_settle_bets(2);

        // Both players have won 10 and the house has lost a total of 20
        assertEq(player.balance, 100 ether + 10 ether);
        assertEq(other_player.balance, 100 ether + 10 ether);
        assertEq(address(roulette).balance, 10_000 ether - 20 ether);
    }

    function test_player_wins_one_bet_loses_another() public {
        // First bet is on Red
        vm.prank(player);
        roulette.place_color_bet{value: 10 ether}(Color.Red);

        // Second, bigger bet is on Green
        vm.prank(player);
        roulette.place_color_bet{value: 20 ether}(Color.Green);

        // Spin is made and Red 19 is the winner;
        // Player wins the small bet, and loses the big bet
        roulette.exposed_settle_bets(19);

        // Player's balance should be the original 100 + 10 of winnings - 20 of losses
        assertEq(player.balance, 100 ether + 10 ether - 20 ether);
    }
}