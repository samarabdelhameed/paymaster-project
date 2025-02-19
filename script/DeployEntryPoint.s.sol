// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "@account-abstraction/contracts/core/EntryPoint.sol";

contract DeployEntryPoint is Script {
    function run() external {
        vm.startBroadcast();
        EntryPoint entryPoint = new EntryPoint();
        console.log("EntryPoint deployed at:", address(entryPoint)); // ✅ تم تصحيح السطر
        vm.stopBroadcast();
    }
}
