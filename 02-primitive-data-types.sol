// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract PrimitiveDataTypes {
    // Boolean (True or False)
    bool public isThatTrue = true;

    /*
      Unsigned Integer
      1- uint8, uint16, ..., uint256 (in steps of 8)
      2- uint is an alias for uint256
    */
    uint8 public u8 = 1;
    uint16 public u16 = 2;
    uint256 public u256 = 123456;
    uint256 public u = 123456;

    /*
      Signed Integer
      1- int8, int16, ..., int256 (in steps of 8)
      2- int is an alias for int256
    */
    int8 public i8 = 1;
    int16 public i16 = 2;
    int256 public i256 = 123456;
    int256 public i = 123456;

    // address: Holds a 20 byte value (size of an Ethereum address).
    address public adr = 0xF07161991efDDb5935295a0B681d0b0204E5FC3E;

    // Bytes
    // 1- fixed sized: bytes1, bytes2, bytes3, …, bytes32
    // 2- dynamically-sized: bytes or string
    bytes1 public a = 0xc4; //  [11000100] = 196
    bytes1 public b = 0x39; //  [00111001] = 57

    // Default values
    // Unassigned variables have a default value
    bool public defaultBool;
    uint256 public defaultUint;
    int256 public defaultInt;
    address public defaultAddr; 
    bytes1 public defaultBytes1;
}
