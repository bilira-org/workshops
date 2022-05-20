// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Students {
    enum Status {
      Passed,
      Failed
    }

    mapping(address => uint8[3]) public studentToGradesMap;

    uint8 passingGrade;

    constructor(uint8 _passingGrade) {
      passingGrade = _passingGrade;
    }

    function setGrades(address _studentAddr, uint8[3] memory _grades) public {
        studentToGradesMap[_studentAddr] = _grades;
    }

    function getSumOfGrades(uint8[3] memory _arr) private pure returns (uint8) {
      uint16 sum;
      for (uint8 i = 0; i < _arr.length; i++) {
        sum += _arr[i];
      }
      return uint8(sum);
    }

    function getAverageGrade(address _studentAddr) public view returns (uint8) {
      uint8[3] memory grades = studentToGradesMap[_studentAddr];
      uint16 sum = getSumOfGrades(grades);
      if (sum > 0 && grades.length > 0) { 
        return uint8(sum / grades.length);
      }
      return 0;
    }

    function getStudentStatus(address _studentAddr) external view returns (Status) {
      return getAverageGrade(_studentAddr) >= passingGrade ? Status.Passed : Status.Failed;
    }
}
