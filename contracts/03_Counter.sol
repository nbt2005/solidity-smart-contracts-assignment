// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Counter {
    uint256 public count;
    uint256 public constant MAX = 100;

    event Incremented(address who, uint256 newCount);
    event Decremented(address who, uint256 newCount);
    event Reset(address who);

    // A configurable start allows the upper boundary to be tested directly.
    constructor(uint256 initialCount) {
        require(initialCount <= MAX, "Initial count exceeds MAX");
        count = initialCount;
    }

    function increment() public {
        require(count < MAX, "Max limit reached");
        count += 1;
        emit Incremented(msg.sender, count);
    }

    function decrement() public {
        require(count > 0, "Count is zero");
        count -= 1;
        emit Decremented(msg.sender, count);
    }

    function reset() public {
        count = 0;
        emit Reset(msg.sender);
    }
}
