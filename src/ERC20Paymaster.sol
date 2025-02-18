// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@account-abstraction/contracts/core/UserOperationLib.sol";  // ✅ مسار صحيح
import "@account-abstraction/contracts/core/BasePaymaster.sol";  // ✅ مسار صحيح
import "@account-abstraction/contracts/interfaces/IEntryPoint.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Paymaster is Ownable, BasePaymaster {
    using UserOperationLib for PackedUserOperation;  // ✅ استخدام `PackedUserOperation` المستورد

    IERC20 public acceptedToken;
    uint256 public immutable rate; // ✅ `rate` أصبح `immutable` لتحسين الكفاءة

    constructor(IEntryPoint _entryPoint, address _tokenAddress, uint256 _rate) BasePaymaster(_entryPoint) {
        // ✅ تعطيل `supportsInterface` لتجنب `Revert` أثناء النشر
        // require(IERC165(address(_entryPoint)).supportsInterface(type(IEntryPoint).interfaceId), "IEntryPoint interface mismatch");

        entryPoint = _entryPoint;
        acceptedToken = IERC20(_tokenAddress);
        rate = _rate;
    }

    /// @notice إيداع التوكنات في العقد
    /// @param amount الكمية التي سيتم إيداعها
    function depositTokens(uint256 amount) external {
        require(acceptedToken.transferFrom(msg.sender, address(this), amount), "Token transfer failed");
    }

    /// @notice التحقق من عملية المستخدم قبل تنفيذها
    /// @param userOp بيانات العملية
    /// @param maxCost أقصى تكلفة للعملية
    function _validatePaymasterUserOp(
        PackedUserOperation calldata userOp,
        bytes32,
        uint256 maxCost
    ) internal view override returns (bytes memory context, uint256 validationData) {  
        uint256 tokenAmount = maxCost * rate;  
        require(acceptedToken.balanceOf(address(this)) >= tokenAmount, "Insufficient Paymaster balance");

        // ✅ إرجاع `context` مناسب لاستخدامه في `postOp`
        return (abi.encode(tokenAmount, userOp.sender), 0);
    }

    /// @notice تنفيذ `postOp` بعد تنفيذ العملية
    /// @param context البيانات التي تم تمريرها من `validatePaymasterUserOp`
    function _postOp(PostOpMode, bytes calldata context, uint256 /* actualGasCost */, uint256) internal override {
        (uint256 tokenAmount, address user) = abi.decode(context, (uint256, address));

        // ✅ خصم الرسوم من رصيد المستخدم
        require(acceptedToken.transferFrom(user, address(this), tokenAmount), "Fee transfer failed");
    }

    /// @notice سحب التوكنات من العقد من قبل المالك
    /// @param to عنوان المستلم
    /// @param amount الكمية التي سيتم سحبها
    function withdrawTokens(address to, uint256 amount) external onlyOwner {
        require(acceptedToken.transfer(to, amount), "Withdrawal failed");
    }
}
