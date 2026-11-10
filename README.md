# Solidity Smart Contract Assignment

**Name:** Nguyễn Bá Thiện

**Roll No:** TODO - fill in before submission

**Email:** nguyenbathien.3112@gmail.com

Solidity assignment using Remix IDE and a local Ganache blockchain. This repository currently contains Contracts 01-03; Contracts 04-15 are pending.

| # | Contract | Level | Tested on Ganache | Screenshots |
|---|---|---|---|---|
| 01 | Storage | Basic | YES - deploy and update | [Compile](screenshots/01_compile.png), [Test](screenshots/01_test.png) |
| 02 | Greeting | Basic | YES - owner update and reset; non-owner attempt recorded | [Compile](screenshots/02_compile.png), [Update](screenshots/02_test1.png), [Non-owner attempt](screenshots/02_test2.png), [Reset](screenshots/02_reset.png), [Ganache](screenshots/02_ganache.png) |
| 03 | Counter | Basic | YES - increment, decrement and reset; boundary attempts recorded | [Compile](screenshots/03_compile.png), [Increment](screenshots/03_test1.png), [Decrement](screenshots/03_decrement.png), [Reset](screenshots/03_reset.png), [Ganache](screenshots/03_ganache.png) |
| 04 | Ownable / ProtectedVault | Medium | NOT YET | Pending |
| 05 | SimpleBank | Medium | NOT YET | Pending |
| 06 | Voting | Medium | NOT YET | Pending |
| 07 | MyToken | Medium | NOT YET | Pending |
| 08 | Crowdfunding | Advanced | NOT YET | Pending |
| 09 | Lottery | Advanced | NOT YET | Pending |
| 10 | TimeLockVault | Advanced | NOT YET | Pending |
| 11 | Escrow | Advanced | NOT YET | Pending |
| 12 | SimpleNFT | Advanced | NOT YET | Pending |
| 13 | EnglishAuction | Expert | NOT YET | Pending |
| 14 | MultisigWallet | Expert | NOT YET | Pending |
| 15 | StakingRewards | Expert | NOT YET | Pending |

## Repository structure

```text
solidity-smart-contracts-assignment/
|-- README.md
|-- contracts/
|   |-- 01_Storage.sol
|   |-- 02_Greeting.sol
|   `-- 03_Counter.sol
|-- screenshots/
|   `-- PNG evidence for Contracts 01-03
`-- report/
    `-- REPORT.md
```

Files for Contracts 04-15 will be added as those exercises are completed.

## How to run

1. Start Ganache QUICKSTART Ethereum at `http://127.0.0.1:7545`.
2. Open Remix IDE and create the `Assignment15` workspace with a `contracts` folder.
3. Copy a source file from this repository into the matching file in Remix.
4. Compile with Solidity **0.8.24**, targeting EVM **paris**. The Ganache workspace used for the screenshots runs the **Merge** hardfork; Paris avoids newer unsupported opcodes.
5. In Deploy & Run Transactions, choose **Custom - External Http Provider** and connect to `http://127.0.0.1:7545`.
6. Select the contract, keep Value at `0 wei`, and enter its constructor argument:

   | Contract | Constructor argument |
   |---|---|
   | Storage | `42` |
   | Greeting | `"Hello, World!"` |
   | Counter | `99` |

7. Deploy, run the checks in [REPORT.md](report/REPORT.md), and match transaction hashes with Ganache.
8. Use only local Ganache test accounts and test ETH.

## Evidence and limitations

- Screenshots are from the student's manual Remix/Ganache sessions. The source files reproduce the code shown in those sessions.
- Owner/boundary failure attempts currently show `missing revert data` during gas estimation. They do not show a mined failed transaction or a decoded revert reason.
- A direct read-only RPC check of Counter at zero returned `Count is zero` from Ganache. This check does not replace the missing Remix screenshot of the decoded reason.
- Event decoding is visible in Remix where captured. Ganache transaction pages currently show `NO EVENTS`; decoded event evidence in Ganache itself remains incomplete.
- A temporary local error-response proxy was tried on port 7546. It is not required to run these contracts and is not included in the submission workflow.
- Fill in student details, finish the remaining contracts and documentation, and review evidence before final submission.

## Report

See [report/REPORT.md](report/REPORT.md) for the purpose, concepts, actual tests, and evidence for each completed contract.
