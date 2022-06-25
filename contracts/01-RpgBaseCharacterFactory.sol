// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract RpgBaseCharacterFactory {

  event  NewCharacterCreated(uint characterId, string name, uint dna);
  
  uint8 dnaDigits = 12;
  uint dnaModulus = 10 ** dnaDigits;

  struct BaseCharacter {
    string name;
    uint dna;
  }

  BaseCharacter[] public characters;
  mapping(uint => address) characterToOwner;
  mapping(address => uint) ownerCharacterCount;

  function _createCharacter(string memory _name, uint _dna) private returns (uint) {
    characters.push(BaseCharacter(_name, _dna));
    uint id = characters.length - 1;
    characterToOwner[id] = msg.sender;
    ownerCharacterCount[msg.sender]++;
    emit NewCharacterCreated(id, _name, _dna);
    return id;
  }

  function _generateRandomDna(string memory _str) private view returns (uint) {
    uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender, _str)));
    return randomNumber % dnaModulus;
  }

  function _createRandomCharacter(string memory _name) internal returns (uint) {
    require(ownerCharacterCount[msg.sender] == 0, "You can only have one character");
    uint newDna = _generateRandomDna(_name);
    uint id = _createCharacter(_name, newDna);
    return id;
  }

}