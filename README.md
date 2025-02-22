# **ERC20 Paymaster - Account Abstraction (ERC-4337)**  

## **📌 Overview**  
`ERC20Paymaster` is an **Account Abstraction (ERC-4337) Paymaster** contract that allows users to pay gas fees using **ERC20 tokens** instead of the native blockchain currency (e.g., ETH).  

### **🚀 Why Use This Paymaster?**  
🔹 **Reduces onboarding friction** – Users don’t need ETH to interact with dApps.  
🔹 **Enhances user experience** – Pay gas fees using stablecoins or other ERC20 tokens.  
🔹 **Supports decentralized gas sponsorship** – dApps can sponsor transactions for users.  
🔹 **Compatible with ERC-4337** – Works seamlessly with the **EntryPoint contract**.  

---

## **📌 Features**  
✅ **Allows gas fee payments with ERC20 tokens**  
✅ **Fully compatible with ERC-4337 `EntryPoint`**  
✅ **Supports arbitrary ERC20 tokens for gas sponsorship**  
✅ **Secure deposit & withdrawal mechanisms**  
✅ **Can be deployed on Ethereum & EVM-compatible chains**  

---

## **📌 How It Works**  

### **User Operation Flow**
1. **User sends a `UserOperation`** from a smart contract wallet (e.g., a Safe Wallet).  
2. **EntryPoint contract** calls `ERC20Paymaster` to validate the transaction.  
3. **Paymaster checks** if the user has enough ERC20 tokens to cover gas fees.  
4. **Paymaster locks the required tokens** before allowing transaction execution.  
5. **After execution,** Paymaster converts tokens into ETH (if required) and pays gas to the EntryPoint.  
6. **Remaining tokens (if any) are refunded** to the user.  

**⚡ Simplified Transaction Flow:**  
```
UserOperation ➝ EntryPoint ➝ Paymaster ➝ Validate Gas Fee ➝ Execute Tx ➝ Pay Gas
```

---

## **📌 Contract Architecture**  

| Contract            | Description |
|---------------------|-------------|
| **ERC20Paymaster.sol** | Core Paymaster contract, validates gas payments with ERC20 tokens |
| **BasePaymaster.sol**  | Provides ERC-4337 Paymaster base logic |
| **EntryPoint.sol**  | Standard ERC-4337 EntryPoint that processes UserOperations |

### **🔹 `ERC20Paymaster.sol` (Main Contract)**
- Extends **`BasePaymaster`** from ERC-4337.  
- Implements `_validatePaymasterUserOp` to verify token balances.  
- Allows deposit & withdrawal of ERC20 tokens for gas sponsorship.  

### **🔹 `BasePaymaster.sol`**
- Abstract contract that defines **Paymaster validation & gas fee logic**.  
- Ensures proper **settlement of transaction fees** with the EntryPoint.  

---

## **📌 Deployment Steps**
The contract is deployed using **Foundry**. Follow these steps to deploy and interact with `ERC20Paymaster`.  

### **1️⃣ Deploy the Contract**  
Use the following **Foundry** command to deploy the contract on **Holesky Testnet**:  

```sh
forge script script/DeployERC20Paymaster.s.sol:DeployScript \
    --rpc-url https://ethereum-holesky.publicnode.com \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --gas-limit 20000000
```

### **✅ Deployment Results:**  
```
ERC20Paymaster deployed at: 0x7EbafcD7f66CCb3F52b9B2cF8e7dF859e5f66a42
Transaction Hash: 0xd5366f7539aba97050fdf5f4ec9537c5dc03a0f311d073fb017e866068f1dfd7
Block Number: 3402951
```

---

## **📌 Contract Verification**  
To verify the contract on **Etherscan**, use:  

```sh
forge script script/DeployERC20Paymaster.s.sol:DeployScript --verify \
    --rpc-url https://ethereum-holesky.publicnode.com \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --gas-limit 20000000 \
    --etherscan-api-key $ETHERSCAN_API_KEY
```

**Etherscan Verification Status:** ✅  
🔗 [View on Holesky Etherscan](https://holesky.etherscan.io/address/0x7EbafcD7f66CCb3F52b9B2cF8e7dF859e5f66a42)  

---

## **📌 Funding the Paymaster**  
Since the Paymaster **does not hold ETH**, we need to **fund it with ERC20 tokens** before use.  

### **1️⃣ Check Paymaster Balance**  
```sh
cast call 0x7EbafcD7f66CCb3F52b9B2cF8e7dF859e5f66a42 \
    "balanceOf(address)(uint256)" \
    0xYourEOAAddress \
    --rpc-url https://ethereum-holesky.publicnode.com
```

### **2️⃣ Deposit ERC20 Tokens**  
```sh
cast send 0xYourERC20TokenAddress \
    "transfer(address,uint256)" \
    0x7EbafcD7f66CCb3F52b9B2cF8e7dF859e5f66a42 \
    1000000000000000000 \
    --rpc-url https://ethereum-holesky.publicnode.com \
    --private-key $PRIVATE_KEY
```

---

## **📌 Using the Paymaster in a User Operation**
Once the Paymaster is **funded**, it can be used in a **UserOperation**.  
To test a transaction:  

```sh
cast send 0x7EbafcD7f66CCb3F52b9B2cF8e7dF859e5f66a42 \
    "handleOps(PackedUserOperation[],address)" \
    "[userOpData]" \
    0xYourBundlerAddress \
    --rpc-url https://ethereum-holesky.publicnode.com \
    --private-key $PRIVATE_KEY
```

✅ **Successful Execution Logs:**  
```
Transaction Hash: 0x654e9c6c40d8fec1ac0a5841ba6b8f739f65d2706068b927d4d59101ddbe3c68
Status: ✅ Success
Gas Used: 36,911
Paymaster Token Balance: Updated
```

---

## **📌 Debugging & Testing**  
### **1️⃣ Checking Paymaster Contract Code**  
```sh
cast code 0x7EbafcD7f66CCb3F52b9B2cF8e7dF859e5f66a42 \
    --rpc-url https://ethereum-holesky.publicnode.com
```
- If **empty (`0x`)**, contract may not be deployed correctly.  

### **2️⃣ Checking Paymaster Balance**  
```sh
cast balance 0x7EbafcD7f66CCb3F52b9B2cF8e7dF859e5f66a42 \
    --rpc-url https://ethereum-holesky.publicnode.com
```
- If **balance is `0`**, fund the contract with ERC20 tokens.  

### **3️⃣ Checking Owner of Paymaster**  
```sh
cast call 0x7EbafcD7f66CCb3F52b9B2cF8e7dF859e5f66a42 \
    "owner()(address)" \
    --rpc-url https://ethereum-holesky.publicnode.com
```
✅ **Expected Output:**  
```
0x1d58afB3a049DAd98Ab5219fb1FF768E1E3B2ED3
```

---

## **📌 Contracts Deployed**
| Contract | Address | Description |
|----------|---------|-------------|
| **ERC20Paymaster** | `0x7EbafcD7f66CCb3F52b9B2cF8e7dF859e5f66a42` | Paymaster contract allowing ERC20-based gas payments |
| **EntryPoint** | `0x41F6A161568039dE347d520fEBaCfCFD41bC4030` | ERC-4337 EntryPoint contract |
| **SimpleAccountFactory** | `0xDb5c0fb749809b8e67f25b75829eAe0451B783D4` | Smart account factory |

---

## **📌 Conclusion**
The **ERC20 Paymaster** successfully enables **ERC20-based gas payments** under the **ERC-4337 Account Abstraction** framework. It is a **flexible and efficient solution** for gas sponsorship, reducing onboarding friction and allowing **dApps to cover gas fees on behalf of users**. 🚀