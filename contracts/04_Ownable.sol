// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Ownable {
    address public owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is zero address");
        address previousOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(previousOwner, newOwner);
    }
}

contract ProtectedVault is Ownable {
    uint256 private treasure;
    event Deposited(address indexed sender, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount);

    function deposit() public payable {
        require(msg.value > 0, "Deposit must be positive");
        treasure += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(address to, uint256 amt) public onlyOwner {
        require(to != address(0), "Recipient is zero address");
        require(amt > 0, "Amount must be positive");
        require(amt <= treasure && amt <= address(this).balance, "Insufficient balance");
        treasure -= amt;
        (bool sent, ) = payable(to).call{value: amt}("");
        require(sent, "ETH transfer failed");
        emit Withdrawn(to, amt);
    }

    function contractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
