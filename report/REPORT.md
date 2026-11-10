# Smart Contract Assignment Report

Scope: Contracts 01-03. The descriptions below distinguish successful transactions from failed gas-estimation attempts. Contracts 04-15 have not yet been completed.

Environment: Remix IDE, Solidity `0.8.24`, EVM target `paris`, Ganache GUI local RPC `http://127.0.0.1:7545` (Merge hardfork).

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

## Remaining work before submission

- Complete Contracts 04-15 and add their own report sections and screenshots.
- Fill in name, roll number, and email in README.md.
- Capture decoded Counter `Incremented` event evidence and clearer revert messages when the tooling permits.
- Verify event logs in Ganache as required by the assignment; current Ganache screenshots prove transactions but show `NO EVENTS`.
- Review all source files against the Remix versions and all screenshot links before committing and pushing.
