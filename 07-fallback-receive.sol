// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract EtherStorage {
    uint256 public lastDepositAmount;
    string public calledFunc;

    function deposit() external payable {
        lastDepositAmount = msg.value;
        calledFunc = "deposit func";
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    fallback() external payable {
        lastDepositAmount = msg.value;
        calledFunc = "fallback func";
    }

    receive() external payable {
        lastDepositAmount = msg.value;
        calledFunc = "receive func";
    }
}
