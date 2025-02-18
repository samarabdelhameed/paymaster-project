# ERC20 Paymaster - Account Abstraction (ERC-4337)

## **Overview**
`ERC20Paymaster` is a **Paymaster** smart contract compatible with **ERC-4337 (Account Abstraction)**, enabling users to pay gas fees using **ERC20 tokens** instead of the native network currency (e.g., ETH).  
🚀 This enhances user experience and allows for more flexible transaction sponsorship.

---

## **📌 Features**
✅ **Pay gas fees with ERC20 tokens**  
✅ **Seamless integration with ERC-4337 `EntryPoint`**  
✅ **Supports token-based gas fee sponsorship**  
✅ **Compatible with Ethereum & EVM-compatible chains**  
✅ **Designed for secure and efficient transactions**  

---

## **📌 How It Works**
1. **Users submit a UserOperation** through a smart contract wallet.  
2. **The EntryPoint contract** calls the `ERC20Paymaster` to validate the transaction.  
3. **The Paymaster verifies** the user's ERC20 balance and locks the required amount for gas fees.  
4. **If validation passes,** the transaction is executed.  
5. **After execution,** the Paymaster settles the gas fees with the EntryPoint.  

---

## **📌 Contract Architecture**
### **🔹 `ERC20Paymaster.sol` (Main Contract)**
- Uses **ERC-4337 `BasePaymaster`** as a parent contract.
- Implements `_validatePaymasterUserOp` to check token balances.
- Allows deposit & withdrawal of ERC20 tokens for gas sponsorship.

### **🔹 `BasePaymaster.sol`**
- An abstract contract from the **Account Abstraction** standard.
- Provides validation and gas fee management for Paymasters.

---

## **📌 Deployment**
To deploy `ERC20Paymaster`, use Foundry with the following command:

```sh
forge script script/ERC20Paymaster.s.sol:DeployScript --rpc-url <YOUR_RPC_URL> --private-key <YOUR_PRIVATE_KEY> --broadcast
