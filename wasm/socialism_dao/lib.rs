//! The DAO has members and some membership request process.
//! To start we'll make it that anyone can freely join.
//! Maybe more realistic, you have to contribute some kind of surplus to the DAO to join.
//!
//! Members contribute all their resources to the DAO voluntarily.
//! The contributions are not enforced, rather this is a voluntary society.
//! It is ones civic duty as a socialist to contribute ALL resources.
//!
//! Every so often the pooled resources are split among the members.
//! Every member is allowed to make a claim stating how much they need, and is expected to claim
//! ONLY what they need. Again, it is one's civic duty as a socialist to claim only what they need,
//! and no more. The payout period (the time between consecutive payouts) is at least 100 blocks.
//! Said another way, the payout frequency is at most one payout per hundred blocks.
//! The period is not fixed because they have to be manually triggered.
//!
//! The goal of socialism is that all members' needs are met when possible, and the distribution is
//! still fair when not all needs can be met. As long as everyone follows their civic duty, all
//! needs can be met when there are enough resources. In times of plenty, all needs may be met, and
//! a surplus may even begin to form. Unfortunately, in times of scarcity, not all members will have
//! their needs met.
#![cfg_attr(not(feature = "std"), no_std, no_main)]
#![allow(dead_code)] // TODO remove when approaching completion 🏁
#![allow(unused)] // TODO remove when approaching completion 🏁

#[ink::contract]
mod socialism_dao {

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
	pub enum SocialismDAOError {
		InkEnvError(String),
		/// You cannot join if you are already a member
		AlreadyAMember,
		/// You cannot exit or claim if you are not presently a member
		NotAMember,
		/// You cannot set your need to zero if it is already zero
		NeedIsAlreadyZero,
		/// All contributions must have some finite positive value
		ZeroValueContributionsForbidden,
	}

	impl From<InkEnvError> for SocialismDAOError {
		fn from(e: InkEnvError) -> Self {
			SocialismDAOError::InkEnvError(format!("{e:?}"))
		}
	}

	pub type Selector = [u8; 4];
	pub type Result<T> = core::result::Result<T, SocialismDAOError>;
	pub type Event = <SocialismDAO as ContractEventBase>::Type;

	#[ink(event)]
	#[derive(Debug)]
	/// A new member joined the Socialism DAO
	pub struct MemberJoined {
		#[ink(topic)]
		joiner: AccountId,
	}

	#[ink(event)]
	#[derive(Debug)]
	/// A member exited the Socialism DAO
	pub struct MemberExited {
		exiter: AccountId,
	}

	#[ink(event)]
	#[derive(Debug)]
	/// Someone has contributed resources to the DAO
	pub struct ResourcesContributed {
		contributor: AccountId,
		amount: Balance,
	}

	#[ink(event)]
	#[derive(Debug)]
	/// Someone has claimed a need to the DAO
	pub struct NeedClaimed {
		claimer: AccountId,
		amount: Balance,
	}

	#[ink(event)]
	#[derive(Debug)]
	/// The payouts were performed
	pub struct PayoutsPerformed {
		block_number: BlockNumber,
		total_payout: Balance,
		remaining_surplus: Balance,
	}

	#[derive(Debug)]
	#[ink::storage_item]
	pub struct Data {
		/// The block in which the most recent payout was made.
		last_payout_block: BlockNumber,

		/// The total number of members in the DAO
		num_members: u64,
	}

	#[ink(storage)]
	pub struct SocialismDAO {
		pub data: Lazy<Data, ManualKey<0x44415441>>,
		/// Existence of a key in this map means that the account is a member
		/// If the associated value is Some, then the user has a need registered with the DAO
		/// If it is None, then the user does not currently need any funds.
		pub members_and_needs: Mapping<AccountId, Option<Balance>, ManualKey<0x42455453>>,
	}

	impl SocialismDAO {
		#[ink(constructor, payable)]
		pub fn new() -> Self {
			let mut data = Lazy::new();

			data.set(&Data {
				// We initialize the last payout to the deployment block number
				// so that we are forced to wait at least one period before the first payout.
				last_payout_block: Self::env().block_number(),
				// No members initially. Each member must join.
				num_members: 0,
			});

			Self { data, members_and_needs: Mapping::new() }
		}

		/// Join as a new member of the society
		#[ink(message)]
		pub fn join(&self) {
			todo!()
		}

		/// Exit the society
		#[ink(message)]
		pub fn exit(&self) {
			todo!()
		}

		/// Helper function to remove a member's needs
		/// This helper is useful because removal involves three storage items
		fn remove_need(member: AccountId) {
			//TODO determine if this method is even necessary anymore.
			// This was useful in solidity because the storage was so primitive.
			todo!()
		}

		/// Check whether an account is a member o the DAO
		fn is_member(x: AccountId) -> bool {
			todo!()
		}

		/// Claim the amount of tokens you need on a roughly 100 block basis.
		///
		/// If you don't claim a need during a period, your need will be treated as zero.
		/// You may call this method multiple times during a period.
		/// Your latest submission will be accepted.
		///
		/// In times of plenty your needs will be met; in times of scarcity they may not be.
		#[ink(message)]
		pub fn claim_need(&self, need: Balance) {
			todo!()
		}

		/// Contribute some of your private funds to the socialism.
		/// As a member of the society, it is your civic duty to call this method as often as you
		/// can.
		///
		/// Although we expect only members to contribute, we will allow donations from non-members
		/// too
		#[ink(message, payable)]
		pub fn contribute(&self) {
			todo!()
		}

		/// Cause the members to be paid according to their needs.
		///
		/// Payouts can happen as frequently as every hundred blocks.
		/// But they must be triggered manually by some account calling this function.
		///
		/// Although we expect that only members will typically call this function, we allow anyone
		/// to do so.
		///
		/// The payout algorithm begins by sorting the members according to their needs with the
		/// lowest needs first. (It may be more gas efficient to maintain a sorted list all along.
		/// really IDK.) Pay them out from the least need to the greatest need.
		/// Each step of the way make sure that the need is less than the even split of the
		/// remaining pot. When we reach a point where members are requesting more than the even
		/// split amount, they only get the even split amount. In these circumstances, the society
		/// is not adequately providing for its members. OTOH, in times of plenty, we will reach the
		/// end of the members list with all members' needs met and still have funds in the pot to
		/// roll over.
		///
		/// DESIGN DECISION: Needs do not get reset. They carry over to the next period.
		/// People who know their typical weekly expense will not have to re-submit each time.
		/// This helps save gas fees, but makes it easier to ignore your civic duty to decrease your
		/// claim when you need less.
		#[ink(message)]
		pub fn trigger_payouts(&mut self) -> Result<()> {
			todo!()
		}

		fn emit_event<EE>(emitter: EE, event: Event)
		where
			EE: EmitEvent<Self>,
		{
			emitter.emit_event(event);
		}
	}
}

// Enhancement: make it work with an userspace asset instead of just the native token.

// Enhancement: When performing payouts, you are probably doing some sorting on-chain.
// Sorting on-chain is inefficient, and a good optimisation is to sort off-chain and
// only check the sorting on-chain. Try that advice.
// Your trigger_payouts function should have a new parameter: the pre-sorted list.

// Enhancement: When the DAO does not have enough resources to meet everyones needs,
// it still must decide which members get how much. The algorithm you coded above is one
// reasonable approach, but there are others. Maybe if the DAO has enough to meet
// 80% of the total need, then every member gets 80% of the total need.
//
// Abstract the payout algorithm into a Solidity `Interface`, and move the existing algo
// to a contract that implements the interface. Then implement the new payout algo as
// a second contract. Try to think of a third way the socialists could divide their
// resources during times of want and implement it.

// Enhancement: Make the minimum payout period configurable in the constructor.
