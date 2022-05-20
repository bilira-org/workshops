// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ContractA {
    uint256 public number;

    function setNumber(uint256 _number) public returns (uint256) {
        number = _number;
        return number;
    }

    function deposit() external payable {}

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract B {
    function setNumberOfContractA(ContractA _contract, uint256 _number) public returns (uint256) {
        uint256 returnedNumber = _contract.setNumber(_number);
        return returnedNumber;
    }

    function setNumberOfContractAFromAddress(address payable _contractAddr, uint256 _number) public returns (uint256) {
        ContractA contractA = ContractA(_contractAddr);
        uint256 returnedNumber = contractA.setNumber(_number);
        return returnedNumber;

    }

    function sendEtherToContractA(ContractA _contract) public payable {
        _contract.deposit{value: msg.value}();
    }

    function getBalanceOfContractA(ContractA _contract) public view returns (uint256) {
        return _contract.getBalance();

    }
}
