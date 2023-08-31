// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/solidity/SocialismDAO.sol";

contract SocialismInitializationTests is Test {
    SocialismDAO public dao;

    event MemberJoined(address joinee);
    event MemberExited(address exiter);
    event ResourcesContributed(address contributor, uint amount);

    function setUp() public virtual {
        dao = new SocialismDAO();
    }

    function test_member_can_join() public {

        // Expect that an event will be emitted
        vm.expectEmit(); // could use args to check more data
        emit MemberJoined(address(0));

        // The member calls the join function
        vm.prank(address(0));
        dao.join();

        // Confirm that the new member is in the storage.
        assert(dao.is_member(address(0)));
    }

    function test_member_can_contribute() public {

        // The member calls the join function
        vm.prank(address(0));
        dao.join();

        // Expect that an event will be emitted
        vm.expectEmit();
        emit ResourcesContributed(address(0), 100 ether);

        // Then the same member contributes
        hoax(address(0), 100 ether);
        dao.contribute{value: 100 ether}();

        // Expect that its balance has increased
        assertEq(address(dao).balance, 100 ether);
    }

    function test_non_member_can_contribute() public {
        //todo
    }

    function test_member_can_exit() public {
        //todo
    }

    function test_non_member_cannot_exit() public {
        //todo
    }

    function test_fallback_function_is_disabled() public {
        vm.expectRevert();
        hoax(address(0), 100 ether);
        payable(address(dao)).transfer(10 ether);
    }
}

contract SocialismClaimsAndPayoutsTest is Test {

    SocialismDAO public dao;
    address alice = 0xaAaAaAaaAaAaAaaAaAAAAAAAAaaaAaAaAaaAaaAa;

    event ResourcesContributed(address contributor, uint amount);
    event NeedClaimed(address claimer, uint amount);
    event PayoutsPerformed(uint block_number, uint total_payout, uint remaining_surplus);

    function setUp() public virtual {
        dao = new SocialismDAO();

        vm.prank(alice);
        dao.join();
    }

    function test_member_can_claim() public {
        // Expect that an event will be emitted
        vm.expectEmit(); // could use args to check more data
        emit NeedClaimed(alice, 10);

        // Make the call
        vm.prank(alice);
        dao.claim_need(10);

        // Check the storage
        assertEq(dao.user_need(alice), 10);
    }

    //TODO lots more cases
}

//TODO maybe also some tests for the quicksort function just to be sure it actually works.
