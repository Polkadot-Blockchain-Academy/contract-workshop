#![cfg_attr(not(feature = "std"), no_std, no_main)]
#![allow(dead_code)] // TODO remove when approaching completion 🏁
#![allow(unused)] // TODO remove when approaching completion 🏁

//! A contract that allows two users to play a game
//! of tic-tac-toe between themselves.
//!
//! In case you've never heard about the [tic-tac-toe](https://en.wikipedia.org/wiki/Tic-tac-toe) game,
//! It is a board game with a square-pattern grid of 3 by 3 cells:
//!
//! ```text
//!  O | X | -
//! ---+---+---
//!  - | - | -
//! ---+---+---
//!  - | - | -
//! ```
//!
//! ### Rules:
//!
//! 1. Two players participate, one using `X` and the other using `O`.
//! 2. The players take turns placing their respective symbols (`X` or `O`) on any empty square of
//!    the grid.
//! 3. The objective is to form a line of three of your symbols horizontally, vertically, or
//!    diagonally.
//! 4. The game ends when one player successfully forms a line of three symbols or when all the
//!    squares are filled without any player achieving a winning line.
//! 5. If a winning line is formed, the player who achieved it is declared the winner.
//! 6. If all squares are filled and no winning line is formed, the game ends in a draw.
#[ink::contract]
mod tictactoe {

	/// Possible winning conditions
	#[derive(Debug, Copy, Clone, PartialEq, Eq, scale::Decode, scale::Encode)]
	#[cfg_attr(feature = "std", derive(ink::storage::traits::StorageLayout, scale_info::TypeInfo))]
	pub enum WinLocation {
		LeftColumn,
		CenterColumn,
		RightColumn,
		TopRow,
		MiddleRow,
		BottomRow,
		UphillDiagonal,
		DownhillDiagonal,
		OpponentSurrender,
	}

	/// Current status of game
	#[derive(Debug, Copy, Clone, PartialEq, Eq, scale::Decode, scale::Encode)]
	#[cfg_attr(feature = "std", derive(ink::storage::traits::StorageLayout, scale_info::TypeInfo))]
	pub enum GameStatus {
		InProgress,
		Won,
		Drawn,
	}

	/// Used to track which player is taking a turn
	#[derive(Debug, Copy, Clone, PartialEq, Eq, scale::Decode, scale::Encode)]
	#[cfg_attr(feature = "std", derive(ink::storage::traits::StorageLayout, scale_info::TypeInfo))]
	pub enum Player {
		One,
		Two,
	}

	/// Defines the storage of your contract.
	#[ink(storage)]
	pub struct TicTacToe {
		/// The first player in the game
		player1: AccountId,
		/// The second player in the game
		player2: AccountId,
		/// The number of turns completed in the game so far
		num_turns: u8,
		/// The 3x3 board of moves
		///
		///  0 | 1 | 2
		/// ---+---+---
		///  3 | 4 | 5
		/// ---+---+---
		///  6 | 7 | 8
		board: [Option<AccountId>; 9],
		/// Game winner
		winner: Option<AccountId>,
		/// Winning location
		win_location: Option<WinLocation>,
		/// Game status
		status: GameStatus,
	}

	/// Errors that can occur upon calling this contract.
	#[derive(Debug, PartialEq, Eq, scale::Encode, scale::Decode)]
	#[cfg_attr(feature = "std", derive(::scale_info::TypeInfo))]
	pub enum Error {
		/// The account trying to perform an action is not eligible because it is not their turn
		WrongPlayer,
		/// The cell you are trying to claim is already occupied
		CellAlreadyTaken,
		/// Cell index is out of range
		InvalidCell,
		/// The player is claiming to have won the game, but their claim is invalid.
		InvalidWinClaim,
		/// The game has not been won
		GameNotWon,
		/// The account performing the action is not a player in the game
		NotAPlayer,
		/// Game is not currently in progress
		GameOver,
	}

	/// Type alias for the contract's `Result` type.
	pub type Result<T> = core::result::Result<T, Error>;

	/// Emitted when someone takes a turn
	#[ink(event)]
	pub struct TurnTaken {
		#[ink(topic)]
		player: AccountId,
		cell_index: u8,
	}

	/// Emitted when the game is won
	#[ink(event)]
	pub struct GameWon {
		#[ink(topic)]
		winner: AccountId,
		win_location: WinLocation,
	}

	/// Emitted when a game is tied
	#[ink(event)]
	pub struct GameTied;

	impl TicTacToe {
		/// Constructor that initializes a new game and a fresh board
		#[ink(constructor)]
		pub fn new(player1: AccountId, player2: AccountId) -> Self {
			todo!()
		}

		/// Return the current state of the board
		#[ink(message)]
		pub fn get_board(&self) -> Result<[Option<AccountId>; 9]> {
			todo!()
		}

		/// Return the current status of the game
		#[ink(message)]
		pub fn get_status(&self) -> Result<GameStatus> {
			todo!()
		}

		/// Return the game winner
		#[ink(message)]
		pub fn get_winner(&self) -> Result<AccountId> {
			todo!()
		}

		/// Take a regular non-winning turn in a tic-tac-toe game
		#[ink(message, payable)]
		pub fn take_turn(&mut self, cell_index: u8) -> Result<()> {
			todo!()
		}

		/// The player thinks this turn will win the game
		/// The on-chain logic does not do the heavy lifting of searching all possible win locations
		/// rather the user is forced to point out exactly where they have won, and the chain
		/// just confirms it.
		#[ink(message, payable)]
		pub fn take_winning_turn(
			&mut self,
			cell_index: u8,
			win_location: WinLocation,
		) -> Result<()> {
			todo!()
		}

		/// Turn taking logic
		/// This is called by both take_turn and take_winning_turn
		pub fn do_take_turn(&mut self, current_player: AccountId, cell_index: usize) -> Result<()> {
			todo!()
		}

		/// Verify if a win is valid.
		pub fn verify_win(&self, winner: AccountId, location: WinLocation) -> bool {
			match location {
				WinLocation::BottomRow =>
					return winner == self.board[6].unwrap() &&
						self.board[6] == self.board[7] &&
						self.board[7] == self.board[8],
				WinLocation::MiddleRow =>
					return winner == self.board[3].unwrap() &&
						self.board[3] == self.board[4] &&
						self.board[4] == self.board[5],
				WinLocation::TopRow =>
					return winner == self.board[0].unwrap() &&
						self.board[0] == self.board[1] &&
						self.board[1] == self.board[2],
				WinLocation::UphillDiagonal =>
					return winner == self.board[2].unwrap() &&
						self.board[2] == self.board[4] &&
						self.board[4] == self.board[6],
				WinLocation::DownhillDiagonal =>
					return winner == self.board[0].unwrap() &&
						self.board[0] == self.board[4] &&
						self.board[4] == self.board[8],
				WinLocation::LeftColumn =>
					return winner == self.board[0].unwrap() &&
						self.board[0] == self.board[3] &&
						self.board[3] == self.board[6],
				WinLocation::CenterColumn =>
					return winner == self.board[1].unwrap() &&
						self.board[1] == self.board[4] &&
						self.board[4] == self.board[7],
				WinLocation::RightColumn =>
					return winner == self.board[2].unwrap() &&
						self.board[2] == self.board[5] &&
						self.board[5] == self.board[8],
				_ => return false,
			}
		}

		/// Give up on the game allowing the other player to win
		#[ink(message, payable)]
		pub fn surrender(&mut self) -> Result<()> {
			todo!()
		}

		// Enhancement: Allow players to bet on a game.
		//
		// Enhancement: Allow ending games early when it is inevitable that a draw
		// will happen, but the board is not yet full. This will require one player
		// proposing an early draw, and the other player accepting.
	}

	#[cfg(test)]
	mod tests {
		use super::*;

		fn default_accounts() -> ink::env::test::DefaultAccounts<ink::env::DefaultEnvironment> {
			ink::env::test::default_accounts::<Environment>()
		}

		fn set_next_caller(caller: AccountId) {
			ink::env::test::set_caller::<Environment>(caller);
		}

		#[ink::test]
		fn test_constructor_works() {
			let default_accounts = default_accounts();
			let tictactoe_game = TicTacToe::new(default_accounts.alice, default_accounts.bob);

			assert_eq!(tictactoe_game.get_board(), Ok([None; 9]));
		}

		#[ink::test]
		fn test_players_can_take_turns() {
			let default_accounts = default_accounts();
			let mut tictactoe_game = TicTacToe::new(default_accounts.alice, default_accounts.bob);

			set_next_caller(default_accounts.alice);
			let player1_turn_result = tictactoe_game.take_turn(4);

			set_next_caller(default_accounts.bob);
			let player2_turn_result = tictactoe_game.take_turn(0);

			assert_eq!(player1_turn_result, Ok(()));
			assert_eq!(player2_turn_result, Ok(()));
			assert_eq!(
				tictactoe_game.get_board(),
				Ok([
					Some(default_accounts.bob),
					None,
					None,
					None,
					Some(default_accounts.alice),
					None,
					None,
					None,
					None
				])
			);
		}

		#[ink::test]
		fn test_players_cant_take_turn_when_not_their_turn() {
			let default_accounts = default_accounts();
			let mut tictactoe_game = TicTacToe::new(default_accounts.alice, default_accounts.bob);

			set_next_caller(default_accounts.bob);
			let player_turn_result = tictactoe_game.take_turn(0);

			assert_eq!(player_turn_result, Err(Error::WrongPlayer));
		}

		#[ink::test]
		fn test_player_can_win_top_row() {
			let default_accounts = default_accounts();
			let mut tictactoe_game = TicTacToe::new(default_accounts.alice, default_accounts.bob);

			set_next_caller(default_accounts.alice);
			tictactoe_game.take_turn(0).ok();

			set_next_caller(default_accounts.bob);
			tictactoe_game.take_turn(3).ok();

			set_next_caller(default_accounts.alice);
			tictactoe_game.take_turn(1).ok();

			set_next_caller(default_accounts.bob);
			tictactoe_game.take_turn(4).ok();

			set_next_caller(default_accounts.alice);
			let winning_turn_result = tictactoe_game.take_winning_turn(2, WinLocation::TopRow);

			assert_eq!(winning_turn_result, Ok(()));
			assert_eq!(tictactoe_game.get_status(), Ok(GameStatus::Won));
			assert_eq!(tictactoe_game.get_winner(), Ok(default_accounts.alice));
		}

		#[ink::test]
		fn test_game_will_draw_once_all_cells_taken() {
			let default_accounts = default_accounts();
			let mut tictactoe_game = TicTacToe::new(default_accounts.alice, default_accounts.bob);

			set_next_caller(default_accounts.alice);
			tictactoe_game.take_turn(0).ok();

			set_next_caller(default_accounts.bob);
			tictactoe_game.take_turn(1).ok();

			set_next_caller(default_accounts.alice);
			tictactoe_game.take_turn(2).ok();

			set_next_caller(default_accounts.bob);
			tictactoe_game.take_turn(3).ok();

			set_next_caller(default_accounts.alice);
			tictactoe_game.take_turn(4).ok();

			set_next_caller(default_accounts.bob);
			tictactoe_game.take_turn(5).ok();

			set_next_caller(default_accounts.alice);
			tictactoe_game.take_turn(6).ok();

			set_next_caller(default_accounts.bob);
			tictactoe_game.take_turn(7).ok();

			set_next_caller(default_accounts.alice);
			tictactoe_game.take_turn(8).ok();

			assert_eq!(tictactoe_game.get_status(), Ok(GameStatus::Drawn));
		}

		#[ink::test]
		fn test_player_can_surrender() {
			todo!()
		}

		#[ink::test]
		fn test_non_player_cant_play() {
			todo!()
		}

		#[ink::test]
		fn test_game_must_be_in_progress_to_play() {
			todo!()
		}

		#[ink::test]
		fn test_cant_take_same_cell_twice() {
			todo!()
		}

		#[ink::test]
		fn test_cant_take_cell_outside_board_bounds() {
			todo!()
		}
	}
}
