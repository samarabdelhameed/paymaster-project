// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/ERC20Paymaster.sol";
import "@account-abstraction/contracts/interfaces/IEntryPoint.sol";

/// @title DeployPaymaster - Deployment script for ERC20Paymaster
contract DeployPaymaster is Script {
    function run() external {
        vm.startBroadcast(); // ✅ يبدأ البث باستخدام المفتاح الخاص

        // ✅ عنوان `EntryPoint` الرسمي على شبكة Holesky Testnet
        IEntryPoint entryPoint = IEntryPoint(0x0576a174D229E3cFA37253523E645A78A0C91B57);  

        // ✅ عنوان توكن `ERC20` الذي نشرته على Holesky
        address token = 0x048AC9bE9365053c5569daa9860cBD5671869188;  

        // ✅ نشر عقد `ERC20Paymaster`
        ERC20Paymaster paymaster = new ERC20Paymaster(entryPoint, token, 1);

        // ✅ طباعة عنوان العقد المنشور
        console.log("ERC20Paymaster deployed at:", address(paymaster));

        vm.stopBroadcast(); // ✅ إيقاف البث
    }
}
