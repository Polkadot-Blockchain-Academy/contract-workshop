// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../VyperTest.sol";

import "../../src/solidity/SocialismDAO.sol";
import "../solidity/SocialismDAO.t.sol";

/// Testing Contract for the Vyper implementation.
/// This inherits from the Solidity test contract and overrides it constructor.
contract VyperSocialismInitializationTests is SocialismInitializationTests, VyperTest {
    function setUp() override public {
        string memory vyperContractPath = "evm/src/vyper/SocialismDAO.vy";
        address vyContractAddress = deployContract(vyperContractPath);
        dao = SocialismDAO(vyContractAddress); 
    }
}

/// Testing Contract for the Vyper implementation.
/// This inherits from the Solidity test contract and overrides it constructor.
/// TODO These tests are failing on the example solutions.
/// IDK wy. Debugging is welcome.
contract VyperSocialismClaimsAndPayoutsTests is SocialismClaimsAndPayoutsTest, VyperTest {
    function setUp() override public {
        string memory vyperContractPath = "evm/src/vyper/SocialismDAO.vy";
        address vyContractAddress = deployContract(vyperContractPath);
        dao = SocialismDAO(vyContractAddress);

        vm.prank(alice);
        dao.join();
    }
}
