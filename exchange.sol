//Basic Decentralized Exchange Smart contract.

// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract DEX {
    // Define variables
    address public owner;
    uint256 public fee;
    mapping(address => mapping(address => uint256)) public balances;

    // Constructor function
    constructor() {
        owner = msg.sender;
        fee = 0.1 ether; // Set default fee to 0.1 ether
    }

    // Deposit function
    function deposit(address token, uint256 amount) external payable {
        require(msg.value == amount, "Amount must match value sent");
        balances[msg.sender][token] += amount;
    }

    // Withdraw function
    function withdraw(address token, uint256 amount) external {
        require(balances[msg.sender][token] >= amount, "Insufficient balance");
        balances[msg.sender][token] -= amount;
        payable(msg.sender).transfer(amount);
    }

    // Trade function
    function trade(address tokenBuy, address tokenSell, uint256 amountBuy, uint256 amountSell) external {
        require(balances[msg.sender][tokenBuy] >= amountBuy, "Insufficient balance");
        require(balances[msg.sender][tokenSell] >= amountSell, "Insufficient balance");

        uint256 feeAmount = (amountBuy * fee) / 100; // Calculate fee
        balances[owner][tokenBuy] += feeAmount; // Add fee to owner's balance

        balances[msg.sender][tokenBuy] -= (amountBuy + feeAmount); // Subtract tokens from buyer's balance
        balances[msg.sender][tokenSell] += amountSell; // Add tokens to buyer's balance

        balances[owner][tokenSell] -= amountSell; // Subtract tokens from owner's balance
        balances[owner][tokenBuy] += amountBuy; // Add tokens to owner's Balance
    }
} 