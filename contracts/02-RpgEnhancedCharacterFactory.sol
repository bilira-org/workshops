// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "./01-RpgBaseCharacterFactory.sol";

contract RpgEnhancedCharacterFactory is RpgBaseCharacterFactory {

  enum Stat {
    Attack,
    Defence
  }

  struct EnhancedCharacter {
    uint id;
    mapping(Stat => uint8) stats;
  }

  uint dnaSectionDigits = dnaDigits / 2;
  uint8 minStatValue = 25;

  EnhancedCharacter[] public enhancedCharacters;

  function _getDnaSections(uint _dna, uint _section) internal view returns (uint32) {
    uint32 result;
  
    // skip first n digit
    for (uint i = 0; i < _section * dnaSectionDigits; i++) {
      _dna /= 10;
    }
    // get next 6 digit
    for (uint i = 0; i < dnaSectionDigits; i++) {
      result += uint32((10 ** i) * (_dna % 10));
      _dna /= 10;
    }

    return result;
  }

  function _calculateStatValue(uint32 _dnaSection, uint8 _min) private pure returns (uint8) {
    uint8 val = uint8(_dnaSection % 100) + 1;
    return val < _min ? _min : val;
  }

  function createRandomCharacter(string memory _name) public returns (uint) {
    uint id = super._createRandomCharacter(_name);
    BaseCharacter storage baseCharacter = characters[id];
    EnhancedCharacter storage character = enhancedCharacters.push();
    character.id = id;
    character.stats[Stat.Attack] = _calculateStatValue(_getDnaSections(baseCharacter.dna, 0), minStatValue);
    character.stats[Stat.Defence] = _calculateStatValue(_getDnaSections(baseCharacter.dna, 1), minStatValue);
    return id;
  }

  function getCharacterStats(uint _characterId) external view returns (uint8[] memory) {
    uint8[] memory statsArray = new uint8[](2);
    EnhancedCharacter storage character = enhancedCharacters[_characterId];
    statsArray[0] = character.stats[Stat.Attack];
    statsArray[1] = character.stats[Stat.Defence];
    return statsArray;
  }
}