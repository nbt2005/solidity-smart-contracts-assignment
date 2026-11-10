// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SimpleBank {
    mapping(address => uint256) private balances;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    function deposit() public payable {
        require(msg.value > 0, "Deposit must be positive");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        // Checks: validate the amount and the callers own balance.
        require(amount > 0, "Amount must be positive");
        require(amount <= balances[msg.sender], "Insufficient balance");

        // Effects: debit the balance before making any external call.
        balances[msg.sender] -= amount;

        // Interactions: send ETH and revert the debit if the transfer fails.
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "ETH transfer failed");
        emit Withdrawn(msg.sender, amount);
    }

    function myBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function bankTotal() public view returns (uint256) {
        return address(this).balance;
    }
}
