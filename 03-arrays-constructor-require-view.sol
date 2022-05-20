// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Student {
    uint8[] public grades;

    constructor(uint8[] memory _grades) {
      grades = _grades;
    }

    function addGrade(uint8 _grade) public returns (uint){
      grades.push(_grade);
      return grades.length;
    }

    function getGrade(uint8 _index) public view returns (uint8) {
      require(_index < grades.length, "Not Valid Index");
      return grades[_index];
    }
}
