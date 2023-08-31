// This file is inspired by https://github.com/0xKitsune/Foundry-Vyper
// With suggestions from some issues / ps, and maybe my own hacking.
// I don't quite remember actually. If we end up liking this, we should offer it back upstream.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

abstract contract VyperTest is Test {

    function compileVyper(string memory fileLocation
    ) public returns (bytes memory byteCode) {
        string[] memory cmds = new string[](2);
        cmds[0] = "vyper";
        cmds[1] = fileLocation;
        bytes memory bytecode = vm.ffi(cmds);
        require(bytecode.length > 0, "Bytecode has zero length");
        return bytecode;
    }

    function compileVyper(
        string memory fileLocation, 
        bytes memory args
    ) public returns (bytes memory byteCodeWithArgs) {
        string[] memory cmds = new string[](2);
        cmds[0] = "vyper";
        cmds[1] = fileLocation;
        bytes memory bytecode =  abi.encodePacked(vm.ffi(cmds), args);
        require(bytecode.length > 0, "Bytecode has zero length");
        return bytecode;
    }

    function deployByteCode(
        bytes memory vyperByteCode
    ) public returns (address contractAddr) {
        require(vyperByteCode.length > 0, "One last check: Bytecode has zero length");
        assembly {
            contractAddr := create(0, add(vyperByteCode, 0x20), mload(vyperByteCode))
        }
        // Both of these failed at some point during testing, but IDK why.
        // When I came back a few weeks later, it was magically working. Hooray!
        require(contractAddr != address(0), "Vyper contract deployment failed 111111");
        require(contractAddr.code.length > 0, "Vyper contract deployment failed 2222222222");
    }

    function deployContract(
        string memory fileLocation
    ) public returns (address contractAddr) {
        return deployByteCode(compileVyper(fileLocation));
    }

    function deployContract(
        string memory fileLocation, 
        bytes memory args
    ) public returns (address contractAddr) {
        return deployByteCode(compileVyper(fileLocation, args));
    }
}