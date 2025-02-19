// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "@account-abstraction/contracts/samples/SimpleAccountFactory.sol";
import "@account-abstraction/contracts/interfaces/IEntryPoint.sol";

contract DeploySimpleAccountFactory is Script {
    function run() external {
        vm.startBroadcast();
        SimpleAccountFactory factory = new SimpleAccountFactory(IEntryPoint(0x0576a174D229E3cFA37253523E645A78A0C91B57));
        console.log("SimpleAccountFactory deployed at:", address(factory));
        vm.stopBroadcast();
    }
}
