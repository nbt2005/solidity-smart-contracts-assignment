# Smart Contract Assignment Report

Scope: Contracts 01-05. The descriptions below distinguish successful transactions from failed gas-estimation attempts. Contracts 06-15 have not yet been completed.

Environment: Remix IDE, Solidity `0.8.24` for Contracts 01-03 and `0.8.34` for Contracts 04-05, EVM target `paris`, Ganache GUI local RPC `http://127.0.0.1:7545` (Merge hardfork).

## 01 Storage

- **What it does:** Stores one unsigned integer, initializes it in the constructor, and provides `set` and `get` functions.
- **Key concept:** Persistent state, constructor initialization, a read-only `view` function, and the `ValueSet(address indexed who, uint256 newValue)` event. `private` limits Solidity-level access; it does not make blockchain data secret.
- **Tested:** Deployed with `42`; `get()` returned `42`; `set(100)` succeeded and `get()` returned `100`. The shared testing session showed a Ganache transaction and a decoded `ValueSet` log. This design has no `require` guard, so a require-revert test is not applicable.
- **Ganache proof:** [Compile/deploy](../screenshots/01_compile.png), [combined Ganache transaction, get() = 100, and Remix ValueSet log](../screenshots/01_test.png).

## 02 Greeting

- **What it does:** Stores a greeting; anyone can read it, while only the deploying owner can change or reset it to `Hello, World!`.
- **Key concept:** `msg.sender`, ownership, the reusable `onlyOwner` modifier, and `GreetingChanged` events. The modifier applies one authorization check to both mutating functions without duplicating the check.
- **Tested:** Read the owner; the owner changed the greeting to `GM Ganache`; a different account attempted `setGreeting` and gas estimation failed, but Remix did not decode the reason. The owner reset the greeting successfully and `greet()` returned `Hello, World!`; the reset event was decoded in Remix. A non-owner reset test is not evidenced.
- **Ganache proof:** [Compile/deploy](../screenshots/02_compile.png), [owner update](../screenshots/02_test1.png), [non-owner attempt](../screenshots/02_test2.png), [reset result](../screenshots/02_reset.png), [GreetingChanged log](../screenshots/02_events.png), [reset transaction in Ganache, block 6](../screenshots/02_ganache.png).

## 03 Counter

- **What it does:** Maintains a counter within `[0, 100]`, with increment, decrement, and explicit reset. A constructor starting value is used to test the upper boundary without sending 100 increment transactions, as permitted in the assignment testing guidance.
- **Key concept:** Constants, boundary checks before arithmetic, public getters, and separate `Incremented`, `Decremented`, and `Reset` events.
- **Tested:** Deployed at `99`, read `MAX = 100`, incremented to `100` (block 8), decremented to `99` (block 9), then reset to `0` (block 10). Further increment at `100` and decrement at `0` failed gas estimation; screenshots do not decode the reasons. A direct read-only RPC simulation at zero separately returned `Count is zero`. `Decremented(…, 99)` and `Reset` logs are captured; a decoded `Incremented` screenshot is still missing.
- **Ganache proof:** [Compile/deploy](../screenshots/03_compile.png), [MAX getter](../screenshots/03_compile_max.png), [increment to 100](../screenshots/03_test1.png), [upper-bound attempt](../screenshots/03_max_revert.png), [decrement event](../screenshots/03_decrement.png), [reset to zero and event](../screenshots/03_reset.png), [lower-bound attempt](../screenshots/03_zero_revert.png), [Ganache reset transaction, block 10](../screenshots/03_ganache.png).

## 04 Ownable and ProtectedVault

- **What it does:** `Ownable` stores the deployer as owner and permits a nonzero-address ownership transfer. `ProtectedVault` inherits the owner getter, `onlyOwner` modifier and transfer function; anyone can deposit positive ETH, while only the current owner can withdraw up to the tracked deposit balance.
- **Key concept:** Inheritance reuses ownership logic. The modifier prevents repeating the authorization check in both `transferOwnership` and `withdraw`. Withdrawal checks the recipient, amount and balance, updates `treasure` before the external call, and checks the call result. The contract is an assignment example; force-sent ETH is not included in `treasure`.
- **Tested:** Compiled with Solidity 0.8.34/Paris and deployed `ProtectedVault` on Ganache in block 11. Account A deposited 1 ETH in block 12; a withdrawal from non-owner B failed gas estimation and was cancelled. A transferred ownership to B in block 13; `owner()` returned B. B withdrew 1 ETH to itself in block 14 and `contractBalance()` returned 0. Transfers to the zero address and withdrawals from the empty vault were also attempted; gas estimation failed and both were cancelled. These failures show `missing revert data`, not decoded reasons. Remix decoded the successful `Withdrawn` event; Ganache transaction pages still show `NO EVENTS`. Ganache's Accounts tab showed approximately 99 ETH for A and 101 ETH for B; the view rounds to two decimals, and gas fees explain the more precise 98.998/100.999 values seen in Remix.
- **Ganache proof:** [Compile/deploy](../screenshots/04_compile.png), [deposit and 1 ETH balance](../screenshots/04_deposit.png), [non-owner attempt](../screenshots/04_nonowner.png), [owner changed](../screenshots/04_transfer.png), [withdrawal and zero balance](../screenshots/04_withdraw.png), [Withdrawn event](../screenshots/04_withdraw_event.png), [zero-owner attempt](../screenshots/04_zero_owner.png), [empty-vault withdrawal attempt](../screenshots/04_insufficient_balance.png), [four successful Ganache transactions](../screenshots/04_ganache_transactions.png), [block 14 withdrawal detail](../screenshots/04_ganache_withdraw.png), [Ganache account balances](../screenshots/04_ganache_balances.png). The balance screenshot is cropped to exclude the test workspace mnemonic.

### Contract 04 deployment record

| Item | Value |
|---|---|
| ProtectedVault | `0x5a1c41c067AF6acbEE06f1759f7f756c4E729cf5` |
| A: original owner / depositor | `0x5700923FdA838B3383853be59f7e8D08fA4b3AED` |
| B: new owner / withdrawal recipient | `0x36810d1bB20456F27c636218f2f749b39b9867a2` |
| Deploy, block 11 | `0xe8d1307233b98fd1800ee9be4d1592038fab8cf69e43807028baec14bcb48436` |
| Deposit, block 12 | `0x77139bdf74c742a122643d1838f2930163432cf1d9ea14d9954f9ad3a3bf1dee` |
| Transfer ownership, block 13 | `0x461ca684b9ea83f75fcf10c13d54e05b2efc683034b31fc80abc7ca73b4175fb` |
| Withdraw, block 14 | `0x0458e60a01d0e1dfed5e8f27ef28705d7ec5b03241a2f5fe18aa7e14c753dacc` |

## 05 SimpleBank

- **What it does:** Maintains a separate deposited ETH balance for each address. Users deposit positive ETH, withdraw only from their own balance, read their own balance with `myBalance()`, and read the contract's ETH balance with `bankTotal()`.
- **Key concept:** Checks-Effects-Interactions: first validate the requested amount against the caller's balance, then debit the mapping, then transfer ETH using `call{value: amount}("")` and require success. A reentrant call sees the already-debited balance, so it cannot withdraw the same credit again; if the transfer fails, the entire transaction reverts, including the debit. This testing session used normal Ganache accounts; an adversarial recipient contract was not tested.
- **Tested:** Compiled and deployed in block 15. A deposited 2 ETH in block 16 and `myBalance()` returned 2 ETH; B deposited 3 ETH in block 17 and `myBalance()` returned 3 ETH. `bankTotal()` returned 5 ETH. A attempted to withdraw 10 ETH: gas estimation failed and the attempt was cancelled; Remix showed `missing revert data`, not the decoded reason. A then withdrew 1 ETH successfully in block 18: A's bank balance became 1 ETH and the bank total became 4 ETH. Both event types were decoded in Remix. Ganache transaction details and account balances were inspected; exact read-only RPC balance checks confirmed the withdrawal increased A's wallet by 1 ETH minus gas.
- **Ganache proof:** [Compile/deploy](../screenshots/05_compile.png), [A deposits 2 ETH](../screenshots/05_deposit_A.png), [B balance 3 ETH](../screenshots/05_deposit_B.png), [total 5 ETH](../screenshots/05_bank_total_5eth.png), [10 ETH overdraw attempt](../screenshots/05_insufficient_balance.png), [A balance 1 ETH after withdrawal](../screenshots/05_withdraw_A.png), [total 4 ETH](../screenshots/05_bank_total_4eth.png), [Deposited event](../screenshots/05_deposit_event.png), [Withdrawn event](../screenshots/05_withdraw_event.png), [Ganache transaction list](../screenshots/05_ganache_transactions.png), [block 18 detail](../screenshots/05_ganache_withdraw.png), [Ganache account balances](../screenshots/05_ganache_balances.png). The account screenshot is cropped to exclude the mnemonic. Ganache's decoded Events pane still shows `NO EVENTS`; Remix supplies the decoded event evidence.

### Contract 05 deployment and balance record

| Item | Value |
|---|---|
| SimpleBank | `0xF07a5a57F41Fc2eD5e114b2547d7dFf2473B5A89` |
| A | `0x5700923FdA838B3383853be59f7e8D08fA4b3AED` |
| B / deployer | `0x36810d1bB20456F27c636218f2f749b39b9867a2` |
| Deployment, block 15 | `0x7174f01c49ae472ba08dba46abb0570cf51e1c4b5fe7fd5c6caa58a57baeec47` |
| A deposit, block 16 | `0xbac28e25aa33147db8debc23e00415c95a9c04980ce4ccabd6dda07dcc105fe6` |
| B deposit, block 17 | `0x5c9c360afc807e109c29aba0e78806114e972197d8cbc35a360ca32155184785` |
| A withdrawal, block 18 | `0xe0ec358d8217ef5c9117c90888e26184d06d5b346d434ce6f7555837fb4401ce` |
| A wallet before withdrawal (block 17), wei | `96998672699259369797` |
| A wallet after withdrawal (block 18), wei | `97998668081287650977` |
| Gas used / effective gas price | `35897` / `128645060 wei` |
| Withdrawal gas fee, wei | `4617971718820` |
| Actual wallet increase, wei | `999995382028281180` |

The exact increase equals `1000000000000000000 - 4617971718820` wei. The balance arithmetic was independently checked with read-only Ganache RPC calls after the UI tests. The bank retains 4 ETH of local test funds: 1 ETH credited to A and 3 ETH credited to B.

## Remaining work before submission

- Complete Contracts 06-15 and add their own report sections and screenshots.
- Fill in name, roll number, and email in README.md.
- Capture decoded Counter `Incremented` event evidence and clearer revert messages when the tooling permits.
- Verify event logs in Ganache as required by the assignment; current Ganache screenshots prove transactions but show `NO EVENTS`.
- Review all source files against the Remix versions and all screenshot links before committing and pushing.
