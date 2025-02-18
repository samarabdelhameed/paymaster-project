// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/ERC20Paymaster.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@account-abstraction/contracts/interfaces/IEntryPoint.sol";
import "@account-abstraction/contracts/interfaces/PackedUserOperation.sol";

// ✅ Mock contract for EntryPoint
contract MockEntryPoint is IEntryPoint {
    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return interfaceId == type(IEntryPoint).interfaceId;
    }

    function depositTo(address) external payable override {}
    function withdrawStake(address payable) external override {}
    function balanceOf(address) external pure override returns (uint256) {  // ✅ تغيير `view` إلى `pure`
        return 1 ether;
    }
    function unlockStake() external override {}
    function addStake(uint32) external payable override {}

    // ✅ Implementing required functions
    function handleOps(PackedUserOperation[] calldata, address payable) external override {}
    function handleAggregatedOps(UserOpsPerAggregator[] calldata, address payable) external override {}

    function getUserOpHash(PackedUserOperation calldata) external pure override returns (bytes32) {  // ✅ `pure`
        return keccak256("mockHash");
    }
    function getSenderAddress(bytes memory) external override {}
    function incrementNonce(uint192) external override {}
    function getNonce(address, uint192) external pure override returns (uint256) {  // ✅ `pure`
        return 0;
    }
    function withdrawTo(address payable, uint256) external override {}
    function getDepositInfo(address) external pure override returns (DepositInfo memory) {  // ✅ `pure`
        return DepositInfo({deposit: 1 ether, staked: false, stake: 0, unstakeDelaySec: 0, withdrawTime: 0});
    }
    function delegateAndRevert(address, bytes calldata) external override {}
}

// ✅ Mock ERC20 token for testing
contract TestToken is ERC20 {
    constructor() ERC20("TestToken", "TT") {
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }
}

contract ERC20PaymasterTest is Test {
    ERC20Paymaster public paymaster;
    TestToken public token;
    MockEntryPoint public entryPoint;
    address public owner;
    address public user;

    function setUp() public {
        owner = address(this);
        user = address(0x123);

        token = new TestToken();  
        entryPoint = new MockEntryPoint();  
        paymaster = new ERC20Paymaster(entryPoint, address(token), 1);

        vm.deal(user, 10 ether);
    }

    function testDepositTokens() public {
        uint256 initialBalance = token.balanceOf(address(paymaster));
        vm.prank(owner);
        token.approve(address(paymaster), 1000);
        paymaster.depositTokens(1000);

        uint256 finalBalance = token.balanceOf(address(paymaster));
        assertEq(finalBalance, initialBalance + 1000, "Deposit failed");
    }

    function testWithdrawTokens() public {
        vm.prank(owner);
        token.approve(address(paymaster), 1000);
        paymaster.depositTokens(1000);

        uint256 initialBalance = token.balanceOf(owner);
        vm.prank(owner);
        paymaster.withdrawTokens(owner, 500);

        uint256 finalBalance = token.balanceOf(owner);
        assertEq(finalBalance, initialBalance + 500, "Withdrawal failed");
    }
}
