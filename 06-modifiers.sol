
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Counter {
  address public owner;
  uint public count;

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Only the owner is allowed to do this.");
    _;
  }

  modifier validAddress(address _addr) {
    require(_addr != address(0), "You can not use zero address.");
    _;
  }

  function changeOwner(address _newOwner) public onlyOwner {
    require(_newOwner != address(0), "You can not use zero address.");
    owner = _newOwner;
  }

  function changeOwner2(address _newOwner) public onlyOwner validAddress(_newOwner) {
    owner = _newOwner;
  }

  function getCount() public view returns (uint) {
    return count;
  }

  function increase() public {
    count++;
  }

  function reset() public onlyOwner {
    count = 0;
  }
}