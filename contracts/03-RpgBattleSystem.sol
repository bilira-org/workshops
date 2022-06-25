// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "./02-RpgEnhancedCharacterFactory.sol";

contract RpgBattleSystem is RpgEnhancedCharacterFactory {

  uint8 hitMissChancePercentage = 25;
  uint16 defaultHealth = 500;
  uint8 maxTurn = 30;
  uint8 precision = 3;
  uint cooldownInSeconds = 50;

  mapping(uint => uint) characterIdToAttackCooldown;

  enum BattleResult {
    AttackerWon,
    TargetWon,
    Draw
  }
  
  event  NewBattleEvent(uint characterId, uint targetId, BattleResult battleResult);

  modifier canAttack(uint _characterId, uint _targetId) {
    require(_targetId < enhancedCharacters.length && _characterId != _targetId, "Invalid Target ID");
    require(
      _characterId < enhancedCharacters.length &&
      characterToOwner[_characterId] == msg.sender,
      "Invalid Character ID"
    );
    require(
      block.timestamp > characterIdToAttackCooldown[_characterId] + cooldownInSeconds,
      "You can not attack too frequently, have a rest for a while.."
    );
    _;
  }

  function _calculateDamage(uint8 _attack, uint8 _targetDefence, uint8 _seed) private view returns (uint) {
    uint chance = (uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender, _seed))) % 100);
 
    return _attack*((100/(_targetDefence+chance))+1);
  }

  function _getBattleResult(int _attackerHp, int _targetHp) private pure returns (BattleResult) {
    if (_attackerHp <= 0) {
      return BattleResult.AttackerWon;
    } else if (_targetHp <= 0) {
      return BattleResult.TargetWon;
    } else {
      return BattleResult.Draw;
    }
  }

  function attack(uint _characterId, uint _targetId) external canAttack(_characterId, _targetId) {
    console.log("\nCharacter[%s] is attacking to Character[%s]", _characterId, _targetId);
    EnhancedCharacter storage attacker = enhancedCharacters[_characterId];
    int attackerHp = int16(defaultHealth);

    EnhancedCharacter storage target = enhancedCharacters[_targetId];
    int targetHp = int16(defaultHealth);
 

    bool isAttackersTurn;
    uint8 turn = 0;
    uint appliedDamage;
    bool missed;

    // Players take their turns
    while (turn < maxTurn && attackerHp > 0 && targetHp > 0) {
      turn++;
      isAttackersTurn = !isAttackersTurn;

      missed = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender, turn))) % 100 <= hitMissChancePercentage;
      if (missed) {
        if (isAttackersTurn) {
          console.log("Attacker missed!");
        } else {
          console.log("Target missed!");
        }
        continue;
      }
      if (isAttackersTurn) {
        appliedDamage = _calculateDamage(attacker.stats[Stat.Attack], target.stats[Stat.Defence], turn);
        targetHp -= int(appliedDamage);
        console.log("Attacker's turn, applying damage: %s", appliedDamage);
      } else {
        appliedDamage = _calculateDamage(target.stats[Stat.Attack], attacker.stats[Stat.Defence], turn);
        attackerHp -= int(appliedDamage);
        console.log("Target's turn, applying damage: %s", appliedDamage);
      }

    }

    characterIdToAttackCooldown[_characterId] = block.timestamp;
    emit NewBattleEvent(_characterId, _targetId, _getBattleResult(attackerHp, targetHp));
  }

}
