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
    uint256 public rate; // عدد التوكنات المطلوبة لكل وحدة غاز

    constructor(IEntryPoint _entryPoint, address _tokenAddress, uint256 _rate) BasePaymaster(_entryPoint) {
        acceptedToken = IERC20(_tokenAddress);
        rate = _rate;
    }

    /// @notice إيداع التوكنات في العقد
    /// @param amount الكمية التي سيتم إيداعها
    function depositTokens(uint256 amount) external {
        require(acceptedToken.transferFrom(msg.sender, address(this), amount), "Token transfer failed");
    }

    /// @notice التحقق من عملية المستخدم قبل تنفيذها
    /// @param maxCost أقصى تكلفة للعملية
    function _validatePaymasterUserOp(
        PackedUserOperation calldata,
        bytes32,
        uint256 maxCost
    ) internal view override returns (bytes memory context, uint256 validationData) {  // ✅ إضافة `view`
        uint256 tokenAmount = maxCost * rate;  
        require(acceptedToken.balanceOf(address(this)) >= tokenAmount, "Insufficient Paymaster balance");

        return ("", 0);
    }

    /// @notice سحب التوكنات من العقد من قبل المالك
    /// @param to عنوان المستلم
    /// @param amount الكمية التي سيتم سحبها
    function withdrawTokens(address to, uint256 amount) external onlyOwner {
        require(acceptedToken.transfer(to, amount), "Withdrawal failed");
    }
}
