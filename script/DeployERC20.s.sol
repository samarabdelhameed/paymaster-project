// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }
}

contract DeployERC20 is Script {
    function run() external {
        vm.startBroadcast();
        MyToken token = new MyToken();
        console.log("ERC20 Token deployed at:", address(token));  // ✅ إزالة الإيموجي لتجنب الخطأ
        vm.stopBroadcast();
    }
}
