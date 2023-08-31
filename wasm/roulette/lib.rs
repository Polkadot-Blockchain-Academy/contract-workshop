//! The Roulette
//! - there is a window of length N blocks for users to place their bets
//! - there are M bets allowed in each such block
//! - after that no more bets can be placed until spin is called and the winnings are paid out
#![cfg_attr(not(feature = "std"), no_std, no_main)]
#![allow(dead_code)] // TODO remove when approaching completion 🏁
#![allow(unused)] // TODO remove when approaching completion 🏁

#[ink::contract]
mod roulette {

    #[cfg(feature = "std")]
    use ink::storage::traits::StorageLayout;
    use ink::{
        codegen::EmitEvent,
        env::{
            call::{build_call, ExecutionInput},
            set_code_hash, DefaultEnvironment, Error as InkEnvError,
        },
        prelude::{format, string::String},
        reflect::ContractEventBase,
        storage::{traits::ManualKey, Lazy, Mapping},
    };
    use scale::{Decode, Encode};

    #[derive(Debug, PartialEq, Eq, Encode, Decode)]
    #[cfg_attr(feature = "std", derive(scale_info::TypeInfo))]
    pub enum RouletteError {
        InkEnvError(String),
        ArithmeticError,
        BetAmountIsTooSmall,
        NoMoreBetsCanBeMade,
        BettingPeriodNotOver,
        NativeTransferFailed(String),
        NotEnoughBalance,
        CallerIsNotTheHouseOwner,
    }

    impl From<InkEnvError> for RouletteError {
        fn from(e: InkEnvError) -> Self {
            RouletteError::InkEnvError(format!("{e:?}"))
        }
    }

    pub type Selector = [u8; 4];
    pub type Result<T> = core::result::Result<T, RouletteError>;
    pub type Event = <Roulette as ContractEventBase>::Type;

    #[ink(event)]
    #[derive(Debug)]
    pub struct BetPlaced {
        #[ink(topic)]
        player: AccountId,
        #[ink(topic)]
        bet_type: BetType,
        amount: Balance,
    }

    #[ink(event)]
    #[derive(Debug)]
    pub struct WheelSpin {
        winning_number: u8,
    }

    #[derive(Debug, Encode, Decode, Clone, Copy, PartialEq, Eq)]
    #[cfg_attr(feature = "std", derive(scale_info::TypeInfo, StorageLayout))]
    pub enum BetType {
        Number(u8),
        Red,
        Black,
        Even,
        Odd,
    }

    #[derive(Debug, PartialEq, Eq, scale::Encode, scale::Decode)]
    #[cfg_attr(feature = "std", derive(scale_info::TypeInfo, StorageLayout))]
    pub struct Bet {
        pub player: AccountId,
        pub bet_type: BetType,
        pub amount: Balance,
    }

    #[derive(Debug)]
    #[ink::storage_item]
    pub struct Data {
        /// represents the contract owner, defaults to the initializer of the contract
        pub house: AccountId,
        /// How long does the betting period last? (measured in blocks)
        pub betting_period_length: BlockNumber,
        /// When did this betting period start? (measured in blocks)
        pub betting_period_start: BlockNumber,
        /// accounting: consecutive bet identifiers
        pub next_bet_id: u32,
        /// maximal number of bets that can be made in a round
        pub maximal_number_of_bets: u8,
        /// minimal amount of native tokens that can be transferred as part of a bet
        pub minimal_bet_amount: Balance,
        /// keeps track of the total potential payouts to make sure all bets can be covered
        pub potential_payouts: Balance,
        // more if needed
    }

    #[ink(storage)]
    pub struct Roulette {
        pub data: Lazy<Data, ManualKey<0x44415441>>,
        pub bets: Mapping<u32, Bet, ManualKey<0x42455453>>,
    }

    impl Roulette {
        #[ink(constructor, payable)]
        pub fn new(
            betting_period_length: BlockNumber,
            maximal_number_of_bets: u8,
            minimal_bet_amount: Balance,
        ) -> Self {
            todo!()
        }

        /// Returns the end of the current betting period
        #[ink(message)]
        pub fn betting_period_end(&self) -> BlockNumber {
            todo!()
        }

        /// Returns true if we are past the betting period
        #[ink(message)]
        pub fn is_betting_period_over(&self) -> bool {
            todo!()
        }

        /// Returns true if there is still place for more bets
        pub fn are_bets_accepted(data: &Data) -> bool {
            todo!()
        }

        /// Returns true if there is still place & time for more bets
        #[ink(message)]
        pub fn can_place_bets(&self) -> bool {
            todo!()
        }

        #[ink(message)]
        pub fn last_winning_number(&self) -> Option<u8> {
            todo!()
        }

        /// Place a bet
        ///
        /// Places a bet from a player along for the native amount of token included in the transaction
        #[ink(message, payable)]
        pub fn place_bet(&mut self, bet_type: BetType) -> Result<()> {
            todo!()
        }

        /// Spin the wheel
        ///
        /// Will also distribute the winnings to the players and reset the state, starting a new
        /// round of bets
        #[ink(message)]
        pub fn spin(&mut self) -> Result<()> {
            todo!()
        }

        /// calculates and transfers payouts to the winning bets
        fn distribute_payouts(&self, winning_number: u8) -> Result<()> {
            todo!()
        }

        /// Reset the state allowing for a new round of bets to be made
        fn reset(&mut self) -> Result<()> {
            todo!()
        }

        fn ensure_house(&self, caller: AccountId) -> Result<()> {
            todo!()
        }

        fn emit_event<EE>(emitter: EE, event: Event)
        where
            EE: EmitEvent<Self>,
        {
            emitter.emit_event(event);
        }
    }

    /// Calculate the payout for a given bet
    ///
    /// returns a potential payout if no winning_number is passed
    fn calculate_payout(bet: &Bet, winning_number: Option<u8>) -> Balance {
        todo!()
    }

    fn is_black(number: u8) -> bool {
        matches!(
            number,
            2 | 4 | 6 | 8 | 10 | 11 | 13 | 15 | 17 | 20 | 22 | 24 | 26 | 28 | 29 | 31 | 33 | 35
        )
    }

    fn is_red(number: u8) -> bool {
        matches!(
            number,
            1 | 3 | 5 | 7 | 9 | 12 | 14 | 16 | 18 | 19 | 21 | 23 | 25 | 27 | 30 | 32 | 34 | 36
        )
    }

    fn is_odd(number: u8) -> bool {
        number % 2 != 0
    }

    fn is_even(number: u8) -> bool {
        number % 2 == 0
    }

    #[cfg(all(test, feature = "e2e-tests"))]
    mod e2e_tests {
        use ink_e2e::build_message;

        use super::*;

        type E2EResult<T> = std::result::Result<T, Box<dyn std::error::Error>>;

        #[ink_e2e::test]
        async fn test_roulette(mut client: ink_e2e::Client<C, E>) -> E2EResult<()> {
            let betting_period_length = 2;
            let maximal_number_of_bets = 3;
            let minimal_bet_amount = 1000000000000;
            let alice = ink_e2e::alice::<ink_e2e::SubstrateConfig>()
                .account_id()
                .clone()
                .0;
            let even_bet = Bet {
                player: alice.into(),
                bet_type: BetType::Even,
                amount: 1000000000000,
            };
            let odd_bet = Bet {
                player: alice.into(),
                bet_type: BetType::Odd,
                amount: 1000000000000,
            };

            let constructor = RouletteRef::new(
                betting_period_length,
                maximal_number_of_bets,
                minimal_bet_amount,
            );

            let roulette = client
                .instantiate(
                    "roulette",
                    &ink_e2e::alice(),
                    constructor,
                    100000000000000,
                    None,
                )
                .await
                .expect("instantiate failed")
                .account_id;

            let tx = build_message::<RouletteRef>(roulette.clone())
                .call(|instance| instance.place_bet(BetType::Even));

            let _ = client
                .call(&ink_e2e::alice(), tx, even_bet.amount, None)
                .await
                .expect("place_bet tx failed");

            let tx = build_message::<RouletteRef>(roulette.clone())
                .call(|instance| instance.place_bet(BetType::Odd));

            let _ = client
                .call(&ink_e2e::alice(), tx, odd_bet.amount, None)
                .await
                .expect("place_bet tx failed");

            let tx = build_message::<RouletteRef>(roulette.clone())
                .call(|instance| instance.place_bet(BetType::Number(7)));

            let third_bet = client
                .call(&ink_e2e::bob(), tx, minimal_bet_amount, None)
                .await;

            assert!(
                third_bet.is_err(),
                "only two bets in betting period are allowed"
            );

            let query = build_message::<RouletteRef>(roulette.clone())
                .call(|instance| instance.is_betting_period_over());

            let is_betting_over = client
                .call_dry_run(&ink_e2e::alice(), &query, 0, None)
                .await;

            assert!(matches!(is_betting_over.return_value(), true));

            let balance_before = client
                .balance(alice.into())
                .await
                .expect("can't read account balance");

            let spin_tx =
                build_message::<RouletteRef>(roulette.clone()).call(|instance| instance.spin());

            let _spin_tx_result = client
                .call(&ink_e2e::bob(), spin_tx, 0, None)
                .await
                .expect("spin tx failed");

            let query = build_message::<RouletteRef>(roulette.clone())
                .call(|instance| instance.last_winning_number());

            let winning_number = client
                .call_dry_run(&ink_e2e::alice(), &query, 0, None)
                .await
                .return_value()
                .expect("should be some");

            let balance_after = client
                .balance(alice.into())
                .await
                .expect("can't read account balance");

            if is_even(winning_number) {
                let payout = calculate_payout(&even_bet, Some(winning_number));
                assert_eq!(balance_after, balance_before + payout);
            } else {
                let payout = calculate_payout(&odd_bet, Some(winning_number));
                assert_eq!(balance_after, balance_before + payout);
            }

            Ok(())
        }
    }
}
